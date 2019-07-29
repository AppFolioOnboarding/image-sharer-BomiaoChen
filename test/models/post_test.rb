require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = Post.new(link: 'https://cdn.learnenough.com/kitten.jpg', caption: 'Image Test')
  end

  test 'should be valid' do
    assert @post.valid?
  end

  test 'link should be present' do
    @post.link = '       '
    assert_not @post.valid?
  end

  test 'link should not be too long' do
    @post.link = 'a' * 2084
    assert_not @post.valid?
  end

  test 'link validation should accept valid links' do
    valid_links = %w[https://www.example.com/c.png
                     http://www.example.com/b.gif
                     www.example.com/a.jpg
                     www.example.com/d.jpeg]
    valid_links.each do |valid_link|
      @post.link = valid_link
      assert @post.valid?, "#{valid_link.inspect} should be valid"
    end
  end

  test 'link validation should reject invalid links' do
    invalid_links = %w[http://
                       https://.
                       abc]
    invalid_links.each do |invalid_link|
      @post.link = invalid_link
      assert_not @post.valid?, "#{invalid_link.inspect} should be invalid"
    end
  end
end
