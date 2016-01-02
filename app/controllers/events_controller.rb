class EventsController < ApplicationController
  before_action :require_login, only: [:new, :my_events, :edit, :update, :create, :pubish]

  def index
    if params[:search]
      @events = Event.where("lower(name) like ? and status = 'Published'", "%#{params[:search].downcase}%" )
    else
      @events = Event.where("starts_at > ? and status = 'Published'", Time.now )
    end
  end

  def show
    @event = Event.find(params[:id])

    if @event.status == "Draft"
      if !current_user || @event.user_id != current_user.id
        flash[:error] = 'This event has not been published yet'
        redirect_to root_path
      end
    end
  end

  def new

  end

  def my_events
    @events = Event.where(user_id: current_user.id)
  end

  def edit
    @event = Event.find(params[:id])

    if current_user.id != @event.user_id
      flash[:error] = 'You are not the author of this event!'
      redirect_to event_path(@event)
    end
  end

  def create
    @event = Event.new(event_params)
    @event.status = "Draft"
    @event.user_id = current_user.id

    if @event.save
      flash[:notice] = 'Event was created successfully!'
      redirect_to new_event_ticket_type_path(@event)
    else
      flash[:error] = 'An error has occured while creating event.'
      redirect_to new_event_path
    end
  end

  def update
    @event = Event.find(params[:id])

    if current_user.id != @event.user_id
      flash[:error] = 'You are not the author of this event!'
      redirect_to event_path(@event)
    elsif @event.update(event_params)
      flash[:notice] = 'Event was updated successfully!'
      redirect_to new_event_ticket_type_path(@event)
    else
      flash[:error] = 'An error has occured while updating event.'
      redirect_to edit_event_path(@event)
    end
  end

  def publish
    @event = Event.find(params[:event_id])

    if @event.ticket_types && @event.ticket_types.count > 0
      @event.status = 'Published'

      if @event.save
        flash[:notice] = 'Event was published successfully!'
        redirect_to event_path(params[:event_id])
      else
        flash[:error] = 'An error occured while publishing event.'
        redirect_to event_path(params[:event_id])
      end
    else
      flash[:error] = 'You must create at least 1 ticket type for this event.'
      redirect_to event_path(params[:event_id])
    end
  end

  def event_params
    params.require(:event).permit(:name, :extended_html_description, :category_id, :venue_id, :starts_at, :ends_at, :hero_image_url)
  end
end
