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

      def delete(num:)
        node.find(".js-delete#{num}").click
        yield node.driver.browser.switch_to.alert
      end

      def delete_and_confirm!(num:)
        node.find(".js-delete#{num}").click
        alert = node.driver.browser.switch_to.alert
        alert.accept
        window.change_to(IndexPage)
      end

      def click_tag!(tag_name, num:)
        node.find(".js-post#{num}").click_on(tag_name)
        window.change_to(IndexPage)
      end

      def clear_tag_filter!
        node.click_on('All Images')
        window.change_to(IndexPage)
      end
    end
  end
end
