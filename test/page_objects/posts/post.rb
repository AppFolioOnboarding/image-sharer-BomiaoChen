module PageObjects
  module Posts
    class Post < AePageObjects::Element
      def link
        node.find('img')[:src]
      end
    end
  end
end
