require 'flow_test_helper'

class PostsCrudTest < FlowTestCase
  test 'add an image' do
    posts_index_page = PageObjects::Posts::IndexPage.visit

    new_post_page = posts_index_page.add_new_post!

    caption = %w[foo bar]
    new_post_page = new_post_page.create_post!(
      link: 'invalid',
      caption: caption.join(', ')
    ).as_a(PageObjects::Posts::NewPage)
    assert_equal 'Image URL Invalid', new_post_page.flash_message('danger')

    post_link = 'https://media3.giphy.com/media/EldfH1VJdbrwY/200.gif'

    post_index_page = new_post_page.create_post!(
      link: post_link,
      caption: caption.join(', ')
    ).as_a(PageObjects::Posts::IndexPage)
    assert_equal 'Post successfully created', post_index_page.flash_message('notice')

    posts_index_page = PageObjects::Posts::IndexPage.visit
    assert posts_index_page.showing_post?(link: post_link, caption: 'foo bar', num: 1)

    show_post_page = PageObjects::Posts::ShowPage.visit(1)
    assert show_post_page.showing_post?(post_link)
  end

  test 'delete an image' do
    cute_puppy_link = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    ugly_cat_link = 'https://i2.wp.com/scrumbles.co.uk/wp-content/uploads/2019/02/pexels-photo-137049.jpeg'
    Post.create!([
      { link: cute_puppy_link, tag_list: 'puppy, cute' },
      { link: ugly_cat_link, tag_list: 'cat, ugly' }
    ])

    posts_index_page = PageObjects::Posts::IndexPage.visit
    assert_equal 2, posts_index_page.posts.count
    assert posts_index_page.showing_post?(link: ugly_cat_link, caption: 'cat ugly', num: 2)
    assert posts_index_page.showing_post?(link: cute_puppy_link, caption: 'puppy cute', num: 1)

    posts_index_page.delete(num: 2) do |confirm_dialog|
      assert_equal 'You Sure?', confirm_dialog.text
      confirm_dialog.dismiss
    end

    posts_index_page = posts_index_page.delete_and_confirm!(num: 2)
    assert_equal 'Image deleted', posts_index_page.flash_message(:notice)

    assert_equal 1, posts_index_page.posts.count
    refute posts_index_page.showing_post?(link: ugly_cat_link, caption: 'cat ugly', num: 2)
    assert posts_index_page.showing_post?(link: cute_puppy_link, caption: 'puppy cute', num: 1)
  end

  test 'view posts associated with a tag' do
    puppy_link_one = 'https://images.pexels.com/photos/356378/pexels-photo-356378.jpeg'
    puppy_link_two = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    cat_link = 'https://i2.wp.com/scrumbles.co.uk/wp-content/uploads/2019/02/pexels-photo-137049.jpeg'
    Post.create!([
      { link: puppy_link_one, tag_list: 'superman, cute' },
      { link: puppy_link_two, tag_list: 'cute, puppy' },
      { link: cat_link, tag_list: 'cat, ugly' }
    ])
    captions = ['superman cute', 'cute puppy', 'cat ugly']

    posts_index_page = PageObjects::Posts::IndexPage.visit
    [puppy_link_one, puppy_link_two, cat_link].each_with_index do |link, i|
      assert posts_index_page.showing_post?(link: link, caption: captions[i], num: i + 1)
    end

    posts_index_page = posts_index_page.click_tag!('cute', num: 1)

    assert_equal 2, posts_index_page.posts.count
    refute posts_index_page.showing_post?(link: cat_link, num: 3)

    posts_index_page = posts_index_page.clear_tag_filter!
    assert_equal 3, posts_index_page.posts.count
  end
end
