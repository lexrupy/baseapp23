class User < ActiveRecord::Base

  acts_as_authentic

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :resources
  has_one :profile

  attr_accessible :login, :email, :name, :password, :password_confirmation

  validates_presence_of   :login
  validates_length_of     :login, :within => 3..40
  validates_uniqueness_of :login, :case_sensitive => false
#  validates_format_of     :login, :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD
#  validates_format_of     :name,  :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
  validates_presence_of   :email
  validates_length_of     :email, :within => 6..100
  validates_uniqueness_of :email, :case_sensitive => false
#  validates_format_of     :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD

  after_create :create_profile

  include AASM
  aasm_column :state
  aasm_initial_state :initial => :pending
  aasm_state :passive
  aasm_state :pending
  aasm_state :active,  :enter => :do_activate
  aasm_state :suspended
  aasm_state :deleted, :enter => :do_delete

  aasm_event :register do
    transitions :from => :passive, :to => :pending, :on_transition => :valid?
  end

  aasm_event :activate do
    transitions :from => :pending, :to => :active
  end

  aasm_event :suspend do
    transitions :from => [:passive, :pending, :active], :to => :suspended
  end

  aasm_event :delete do
    transitions :from => [:passive, :pending, :active, :suspended], :to => :deleted
  end

  aasm_event :unsuspend do
    transitions :from => :suspended, :to => :active,  :guard => Proc.new {|u| !u.activated_at.blank? }
    transitions :from => :suspended, :to => :pending#, :guard => Proc.new {|u| !u.activation_code.blank? }
    transitions :from => :suspended, :to => :passive
  end

  def exibition_name
    if !self.profile.nil? && (!self.profile.nick_name.blank? || !self.profile.real_name.blank?)
      self.profile.nick_name.blank? ? self.profile.real_name : self.profile.nick_name
    else
      login
    end
  end

  # has_role? simply needs to return true or false whether a user has a role or not.
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role)
    # Master User always have access to all
    list ||= self.roles.collect(&:name)
    role = [role] unless role.is_a? Array
    role.any? { |r| list.include?(r.to_s) } || list.include?('admin') || self.master?
  end

  def have_access?(resource)
    # Master User always have access to all
    return true if self.master?
    # cache the acl hash
    @have_access ||= {}
    @have_access[resource.to_s] ||= begin
      res = Resource.find_by_resource(resource)
      return_value = false
      # if acl is not defined, everibody have access by default
      if res.nil?
        return_value = true
      else
        # grant acces from user acls
        if resource_ids.include? res.id
          return_value = true
        else
          # verify if user is in a role that have access to that resource
          roles.each do |r|
            return_value = true if r.resource_ids.include? res.id
          end
        end
      end
      return_value
    end
  end

  # Creates a new password for the user, and notifies him with an email
  def reset_password!
    password = PasswordGenerator.random_pronouncable_password(3)
    self.password = password
    self.password_confirmation = password
    save
    UserMailer.deliver_reset_password(self)
  end

  def forgot_password
    UserMailer.deliver_forgot_password(self)
  end

  def self.find_by_login_or_email(login_or_email)
    find(:first, :conditions => ['login = ? OR email = ?', login_or_email, login_or_email])
  rescue
    nil
  end

  def recently_activated?
    @activated
  end

  def do_delete
    self.deleted_at = Time.now.utc
  end

  def do_activate
    @activated = true
    self.activated_at = Time.now.utc
    self.deleted_at = nil
  end

  protected

  def create_profile
    # Give the user a profile
    self.profile = Profile.create
  end

  def session_time_out
    time = configatron.session_time_out.to_i
    time.minutes
    5.seconds
  end
end
