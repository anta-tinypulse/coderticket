require 'rails_helper'

RSpec.describe "users/signup", :type => :view do
  it "displays the signup form" do
    assign(:user, User.new())
    render
    expect(rendered).to include("Register now to gain access to exclusive events in Vietnam!")
  end
end

RSpec.describe "users/login", :type => :view do
  it "displays the login form" do
    assign(:user, User.new())
    render
    expect(rendered).to include("Login now to gain access to exclusive events in Vietnam!")
  end
end