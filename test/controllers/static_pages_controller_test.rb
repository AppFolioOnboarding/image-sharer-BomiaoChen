require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_path

    assert_response :ok
    assert_select 'p', 'This is the home page for the image sharer made by Bomiao Chen'
  end
end
