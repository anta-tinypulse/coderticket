require 'rails_helper'

RSpec.describe "routing to sign_up", :type => :routing do
  it "routes /sign_up to users#signup" do
    expect(:get => "/signup").to route_to(
                                      :controller => "users",
                                      :action => "signup"
                                  )
  end

  it "routes /my_events to events#my_events" do
    expect(:get => "/my_events").to route_to(
                                      :controller => "events",
                                      :action => "my_events"
                                  )
  end

  it "routes /order to order#create" do
    expect(:post => "/order").to route_to(
                                     :controller => "orders",
                                     :action => "create"
                                 )
  end
end