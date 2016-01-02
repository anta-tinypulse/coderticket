class VenuesController < ApplicationController
  before_action :require_login

  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      flash[:notice] = 'Venue was created successfully!'
    else
      flash[:error] = 'An error has occured while creating venue.'
    end

    redirect_to new_event_path
  end

  def venue_params
    params.require(:venue).permit(:name, :full_address, :region_id)
  end
end