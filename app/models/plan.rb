# frozen_string_literal: true

# :Plan Model:
class Plan < ApplicationRecord
  belongs_to :product
  has_many :subscriptions, dependent: :destroy
end
