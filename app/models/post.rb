class Post < ApplicationRecord
  acts_as_taggable_on :tags

  VALID_LINK_REGEX = %r{(http(s?):)?([/|.|\w|\s|-])*\.(?:jpg|gif|png|jpeg)}.freeze
  validates :link, presence: true, length: { maximum: 2083 },
                   format: { with: VALID_LINK_REGEX }
end
