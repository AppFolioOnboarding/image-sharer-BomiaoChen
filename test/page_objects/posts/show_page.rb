require 'page_objects/posts/post'

module PageObjects
  module Posts
    class ShowPage < PageObjects::Document
      path :post

      element :post, locator: '#js-post', is: PageObjects::Posts::Post

      def showing_post?(link)
        post.link == link
      end
    end
  end
end
