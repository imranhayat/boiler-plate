# frozen_string_literal: true

# :Plan Model:
class Plan < ApplicationRecord
  belongs_to :product
  validates :nickname, uniqueness: true
  has_many :subscriptions, dependent: :destroy

  def self.any_monthly_plan_present?
    where(interval: 'month').exists?
  end

  def self.any_yearly_plan_present?
    where(interval: 'year').exists?
  end

end
