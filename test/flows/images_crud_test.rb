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

  test 'view images associated with a tag' do
    puppy_url_1 = 'http://www.pawderosa.com/images/puppies.jpg'
    puppy_url_2 = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    cat_url = 'http://www.ugly-cat.com/ugly-cats/uglycat041.jpg'
    Image.create!([
      { url: puppy_url_1, tag_list: 'superman, cute' },
      { url: puppy_url_2, tag_list: 'cute, puppy' },
      { url: cat_url, tag_list: 'cat, ugly' }
    ])

    images_index_page = PageObjects::Images::IndexPage.visit
    [puppy_url_1, puppy_url_2, cat_url].each do |url|
      assert images_index_page.showing_image?(url: url)
    end

    images_index_page = images_index_page.images[1].click_tag!('cute')

    assert_equal 2, images_index_page.images.count
    refute images_index_page.showing_image?(url: cat_url)

    images_index_page = images_index_page.clear_tag_filter!
    assert_equal 3, images_index_page.images.count
  end
end
