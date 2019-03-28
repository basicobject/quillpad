class Post < ApplicationRecord
  extend FriendlyId
  include PgSearch

  friendly_id :title, use: :slugged
  scope :published, -> { where(is_published: true).order('id DESC') }

  pg_search_scope :search_for,
    against: %i(title content),
    using: {
      tsearch: {
        prefix: true,
        negation: true
      }
    }

  KINDS = ['default', 'bookmark', 'secure']

  validates :kind, presence: true
  validates :kind, inclusion: { in: KINDS }

  belongs_to :user, counter_cache: true

  def published?
    is_published
  end
end
