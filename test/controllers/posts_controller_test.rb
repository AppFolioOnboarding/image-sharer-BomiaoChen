require 'test_helper'

class PostControllerTest < ActionDispatch::IntegrationTest
  test 'should get link and tag list and caption' do
    get new_post_path

    assert_response :ok
    assert_select '.js-link', 'Link *'
    assert_select '.js-tag_list', 'Tag list'
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

    assert_redirected_to posts_path
    assert_equal new_post.link, 'https://cdn.learnenough.com/kitten.jpg'
  end

  test 'should get post information' do
    post = Post.create!(link: 'https://cdn.learnenough.com/kitten.jpg')
    post.tag_list.add('cat')
    get post_path(post)

    assert_response :ok
    assert_select 'img[src=?]', 'https://cdn.learnenough.com/kitten.jpg'
    assert_not post.tag_list.empty?
  end

  test 'should go back home if id is invalid' do
    get post_path(-1)

    assert_redirected_to new_post_path
    assert_equal 'Image not found', flash[:error]
  end

  test 'should get All images in home page' do
    get posts_path

    assert_response :ok
    assert_select '.js-title', 'All Images'
    assert_select 'a[href=?]', new_post_path
    assert_select 'image', count: Post.count
  end

  test 'image in reverse order' do
    post_first = Post.create!(link: 'https://cdn.learnenough.com/kitten.jpg')
    post_second = Post.create!(link: 'https://images.pexels.com/photos/356378/pexels-photo-356378.jpeg')
    get posts_path

    assert_response :ok
    assert_select 'img' do |elements|
      assert_equal elements.first.values[2], post_second.link
      assert_equal elements.last.values[2], post_first.link
    end
  end

  test 'images are with associated tags link' do
    post_first = Post.create!(link: 'https://cdn.learnenough.com/kitten.jpg')
    post_first.tag_list.add('cat')
    post_first.tag_list.add('animal')
    post_first.save
    get posts_path

    assert_response :ok
    assert_select '.js-tag', 'Tags:'
    assert_select 'a', 'cat'
    assert_select 'a', 'animal'
  end

  test 'tag should link to filtered images' do
    post_first = Post.create!(link: 'https://cdn.learnenough.com/kitten.jpg')
    post_first.tag_list.add('cat')
    post_first.save
    get posts_path(tag: 'cat')

    assert_response :ok
    assert_select 'a[href=?]', new_post_path
    assert_select 'a[href=?]', posts_path
    assert_select 'img[src=?]', 'https://cdn.learnenough.com/kitten.jpg'
  end

  test 'Invalid tag should redirect to posts' do
    get posts_path(tag: 'wrong')

    assert_redirected_to posts_path
    assert_equal 'Tag not found', flash[:error]
  end

  test 'delete posts should work' do
    post_first = Post.create!(link: 'https://cdn.learnenough.com/kitten.jpg')
    post_first.save

    assert_difference('Post.count', -1) do
      delete post_path(post_first.id)
    end

    assert_redirected_to posts_path
    assert_equal 'Image deleted', flash[:notice]
  end

  test 'invalid delete posts should not work' do
      assert_difference('Post.count', 0) do
        delete post_path(1)
      end

      assert_redirected_to new_post_path
      assert_equal 'Image not found', flash[:error]
    end
end
