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

    new_post = Post.last

    assert_redirected_to root_path
    assert_equal new_post.link, 'https://cdn.learnenough.com/kitten.jpg'
  end

  test 'should get post information' do
    post = Post.create!(link: 'https://cdn.learnenough.com/kitten.jpg')
    get post_path(post)

    assert_response :ok
    assert_select 'img[src=?]', 'https://cdn.learnenough.com/kitten.jpg'
  end

  test 'should go back home if id is invalid' do
    get post_path(-1)

    assert_redirected_to new_post_path
    assert_equal 'Image not found', flash[:error]
  end

  test 'should get All images in home page' do
    get root_path

    assert_response :ok
    assert_select '.js-title', 'All Images'
    assert_select 'a[href=?]', new_post_path
    assert_select 'image', count: Post.count
  end
end