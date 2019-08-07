require 'selenium-webdriver'
require 'page_objects/posts/post'

module PageObjects
  module Posts
    class IndexPage < PageObjects::Document
      path :posts

      collection :posts, locator: '.js-posts', item_locator: '.js-post', contains: PageObjects::Posts::Post

      def add_new_post!
        node.click_on('New Image')
        window.change_to(NewPage)
      end

      def showing_post?(link:, caption: nil, num:)
        posts.any? do |post|
          post.link == link && node.find(".js-post#{num}").text == caption
        end
      end
