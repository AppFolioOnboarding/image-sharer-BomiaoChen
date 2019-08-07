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
    cute_puppy_url = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    ugly_cat_url = 'http://www.ugly-cat.com/ugly-cats/uglycat041.jpg'
    Image.create!([
      { url: cute_puppy_url, tag_list: 'puppy, cute' },
      { url: ugly_cat_url, tag_list: 'cat, ugly' }
    ])

    images_index_page = PageObjects::Images::IndexPage.visit
    assert_equal 2, images_index_page.images.count
    assert images_index_page.showing_image?(url: ugly_cat_url)
    assert images_index_page.showing_image?(url: cute_puppy_url)

    image_to_delete = images_index_page.images.find do |image|
      image.url == ugly_cat_url
    end
    image_show_page = image_to_delete.view!

    image_show_page.delete do |confirm_dialog|
      assert_equal 'Are you sure?', confirm_dialog.text
      confirm_dialog.dismiss
    end

    images_index_page = image_show_page.delete_and_confirm!
    assert_equal 'You have successfully deleted the image.', images_index_page.flash_message(:success)

    assert_equal 1, images_index_page.images.count
    refute images_index_page.showing_image?(url: ugly_cat_url)
    assert images_index_page.showing_image?(url: cute_puppy_url)
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
