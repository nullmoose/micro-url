class Link < ApplicationRecord
  validates :original_url, presence: true, format: URI::regexp(%w[http https])
end