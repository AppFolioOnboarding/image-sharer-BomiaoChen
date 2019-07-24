require 'test_helper'

class PostControllerTest < ActionDispatch::IntegrationTest
  test 'should get link and caption' do
    get new_post_path

    assert_response :ok
    assert_select '.js-link', 'Link *'
    assert_select '.js-caption', 'Caption'
  end
end
