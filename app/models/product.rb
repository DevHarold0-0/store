class Product < ApplicationRecord
  include Notifications

  has_many :subscribers, dependent: :destroy
  has_one_attached :featured_image
  has_rich_text :description

  after_update_commit :notify_subscribers, if: :back_in_stock?

  def back_in_stock?
    inventory_count_previously_was.zero? && inventory_count > 0
  end

  def inventory_count
    if has_attribute?(:inventory_count)
      self[:inventory_count].to_i
    elsif has_attribute?(:inventory)
      self[:inventory].to_i
    elsif has_attribute?(:stock)
      self[:stock].to_i
    else
      0
    end
  end

  def inventory_count?
    inventory_count.to_i > 0
  end

  def notify_subscribers
    subscribers.each do |subscriber|
      ProductMailer.with(product: self, subscriber: subscriber).in_stock.deliver_later
    end
  end
end
