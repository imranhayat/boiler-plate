class MonetizeUser < ActiveRecord::Migration[5.2]
  def change
  	add_monetize :users, :balance, currency: { present: false }
  end
end
