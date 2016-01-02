class TicketTypesController < ApplicationController
  before_action :require_login

  def new
    @event = Event.find(params[:event_id])
  end

  def create
    @event = Event.find(params[:event_id])

    @ticket_type = TicketType.new(ticket_type_params)
    @ticket_type.event_id = params[:event_id]

    if @ticket_type.save
      flash[:notice] = 'Ticket type was created successfully!'
    else
      flash[:error] = 'An error has occured while creating ticket type.'
    end

    redirect_to new_event_ticket_type_path(@event)
  end

  def ticket_type_params
    params.require(:ticket_type).permit(:name, :price, :max_quantity)
  end
end