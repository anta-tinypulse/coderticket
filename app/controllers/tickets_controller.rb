class TicketsController < ApplicationController
  def new
    @event = Event.find(params[:event_id])

    if @event.starts_at < Time.now
      flash[:error] = 'This event has been closed'
      redirect_to event_path(params[:event_id])
    else
      @quantities = {}

      @event.ticket_types.each do |type|
        @quantities[type.id] = params[:quantity] ? params[:quantity]["#{type.id}"] : '0'
      end
    end
  end
end
