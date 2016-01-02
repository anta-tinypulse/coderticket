require 'rails_helper'

describe Event do

  before(:each) { @event = Event.new(name: 'My Event') }

  subject { @event }

  it { should respond_to(:name) }

  it "won't save when required fields are blank" do
    expect(@event.save).to be false
  end

  it "saves successfully when required fields are not empty" do
    @event.extended_html_description = 'abc'
    @event.venue = Venue.new
    @event.category = Category.new
    @event.starts_at = Time.now

    expect(@event.save).to be true
  end

end
