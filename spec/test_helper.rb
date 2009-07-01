require 'authlogic/test_case'

# Stubs the controller authorize_user method to behave like an authenticated user
def do_login
  activate_authlogic
  # TODO: Create a mock user
  user_mock = mock('User')
  user_mock.stubs(:has_role? => true, :have_access? => true)

  session_mock = mock('UserSession')
  session_mock.stubs(:user).returns(user_mock)

  controller.stubs(:current_user_session).returns(session_mock)
  controller.stubs(:authorize_user).returns(true)
  # TODO: Inspect what reason I don't realize this method is needed
  #controller.stubs(:mocha_mock_url).returns('http://test.host')
end

def do_authorize
  do_login
  controller.stubs(:authorized?).returns(true)
end

def expects_paginate(klass, results, options={})
  klass.expects(:paginate).with(
    options.reverse_merge(:page => nil, :per_page => 10)
  ).returns(results)
end

def paginate_results(results)
  @paginate_results ||= begin
     res = [results]
     res.stubs(:page_count).returns(1)
     res
   end
end

