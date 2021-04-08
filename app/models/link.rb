class Link < ApplicationRecord
  validates :original_url, presence: true, format: URI::regexp(%w[http https])
  validates :short_slug, presence: true
  validates :admin_slug, presence: true

  before_validation :generate_slugs, on: :create

  scope :unexpired, -> { where(expired: false) }

  private

  def generate_slugs
    self.short_slug = SecureRandom.uuid[0..10]
    self.admin_slug = SecureRandom.uuid[0..10]
  end
end