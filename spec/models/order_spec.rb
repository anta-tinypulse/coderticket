require 'rails_helper'

describe Order do

  before(:each) { @order = Order.new(first_name: 'abc', last_name: 'adf') }

  subject { @order }

  it { should respond_to(:first_name) }

  it { should respond_to(:last_name) }

  it "won't save when required fields are blank" do
    expect(@order.save).to be false
  end

  it "saves successfully when required fields are not blank" do
    @order.address = 'abc'
    expect(@order.save).to be true
  end
end
