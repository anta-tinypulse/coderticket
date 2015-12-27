class EventsController < ApplicationController
  def index
    if params[:search]
      @events = Event.where("lower(name) like ?", "%#{params[:search].downcase}%" )
    else
      @events = Event.where("starts_at > ?", Time.now )
    end
  end

  def show
    @event = Event.find(params[:id])
  end
end
