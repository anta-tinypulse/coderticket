class AddEventToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :event, index: true, foreign_key: true
  end
end
