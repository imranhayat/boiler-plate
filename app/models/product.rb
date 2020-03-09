# frozen_string_literal: true

# :Product Model:
class Product < ApplicationRecord
  has_many :plans, dependent: :destroy
end
