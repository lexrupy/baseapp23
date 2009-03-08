require 'test_helper'

class TicketMailerTest < ActionMailer::TestCase
  test "create" do
    @expected.subject = 'TicketMailer#create'
    @expected.body    = read_fixture('create')
    @expected.date    = Time.now

    assert_equal @expected.encoded, TicketMailer.create_create(@expected.date).encoded
  end

  test "update" do
    @expected.subject = 'TicketMailer#update'
    @expected.body    = read_fixture('update')
    @expected.date    = Time.now

    assert_equal @expected.encoded, TicketMailer.create_update(@expected.date).encoded
  end

end
