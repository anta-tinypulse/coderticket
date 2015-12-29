class EventsController < ApplicationController
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

  def create
    @event = Event.new(event_params)
    @event.status = "Draft"
    @event.user_id = current_user.id
    @event.save!

    flash[:notice] = 'Event was created successfully'
    redirect_to root_path
  end

  def publish
    @event = Event.find(params[:event_id])
    @event.status = 'Published'
    @event.save!

    flash[:notice] = 'Event was published successfully'
    redirect_to event_path(params[:event_id])
  end

  def event_params
    params.require(:event).permit(:name, :extended_html_description, :category_id, :venue_id, :starts_at, :ends_at, :hero_image_url)
  end
end
