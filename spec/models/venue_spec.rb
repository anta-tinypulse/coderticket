require 'rails_helper'

describe Venue do

  before(:each) { @venue = Venue.new(name: 'abc') }

  subject { @venue }

  it { should respond_to(:name) }

  it { should respond_to(:id) }

  it "won't save when name is not unique" do
    expect(@venue.save).to be true

    @venue2 = Venue.new(name: 'abc')
    expect(@venue2.save).to be false
  end
end
