module PageObjects
  module Posts
    class NewPage < PageObjects::Document
      path :new_post
      path :posts # from fail create

      form_for :post do
        element :link
        element :tag_list
      end

      def create_post!(link: 'https://cdn.learnenough.com/kitten.jpg', caption: 'cat, animal')
        post.link.set link
        post.tag_list.set caption

        node.click_button('Create Post')

        window.change_to do |query|
          query.matches(self.class) { |new_page| new_page.find('form').present? }
          query.matches(IndexPage) { |index_page| index_page.find('.js-posts').present? }
        end
      end
    end
  end
end
