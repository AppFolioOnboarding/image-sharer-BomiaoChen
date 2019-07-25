require 'test_helper'

class PostControllerTest < ActionDispatch::IntegrationTest
  test 'should get link and caption' do
    get new_post_path

    assert_response :ok
    assert_select '.js-link', 'Link *'
    assert_select '.js-caption', 'Caption'
  end

  test 'invalid post information' do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: {
        link: 'abc',
        caption: 'test'
      } }
    end

    assert_response :ok

    assert_select '.alert-danger', 'Image URL Invalid'
    assert_select '.js-link', 'Link *'
  end

  test 'valid post information' do
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { link: 'https://cdn.learnenough.com/kitten.jpg',
                                         caption: '' } }
    end

    assert_response :ok

    new_post = Post.last
    assert_equal new_post.link, 'https://cdn.learnenough.com/kitten.jpg'
  end
end
