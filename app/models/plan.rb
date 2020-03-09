# frozen_string_literal: true

# :Plan Model:
class Plan < ApplicationRecord
  belongs_to :product
end
