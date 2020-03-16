# frozen_string_literal: true

# :Product Model:
class Product < ApplicationRecord
  validates :name, uniqueness: true
  has_many :plans, dependent: :destroy
end
