class Order < ActiveRecord::Base
  has_many :order_details

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true
end
