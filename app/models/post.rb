class Post < ApplicationRecord
  extend FriendlyId
  include PgSearch::Model

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

  KINDS.each do |kind|
    define_method "#{kind}?" do
      self.kind == kind
    end
  end

  def publish!
    update_attribute(:is_published, true)
  end

  def unpublish!
    update_attribute(:is_published, false)
  end
end
