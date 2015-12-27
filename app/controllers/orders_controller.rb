class OrdersController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
    errors = validate_request

    if errors.length > 0
      flash[:error] = errors.join("<br/>").html_safe
      redirect_to new_event_ticket_path(request.parameters)
    end
  end

  def create
    @event = Event.find(params[:order][:event_id])
    errors = validate_request

    if errors.length > 0
      flash[:error] = errors.join("<br/>").html_safe
      redirect_to new_event_order_path(build_params)
    else
      @order = Order.new(order_params)

      params[:quantity].each do |key, value|
        order_details = OrderDetail.new(ticket_type_id: key, quantity: value)
        order_details.ticket_type.max_quantity -= value.to_i
        @order.order_details << order_details
      end

      begin
        Order.transaction do
          @order.save!
          @order.order_details.each do |od|
            od.ticket_type.save!
          end
        end

        flash[:notice] = 'Your order was placed successfully'
        redirect_to root_path
      rescue
        @order.errors.each do |key, value|
          errors << "#{key} #{value}"
        end

        flash[:error] = errors.join("<br/>").html_safe
        redirect_to new_event_order_path(build_params)
      end
    end
  end

  private
  def validate_request
    hasTicket = false
    errors = []

    @event.ticket_types.each do |type|
      if params[:quantity]["#{type.id}"]
        quantity = params[:quantity]["#{type.id}"].to_i

        if quantity > 0
          hasTicket = true

          if type.max_quantity < quantity
            errors << "You cannot select more than #{type.max_quantity} ticket(s) for #{type.name}"
          end
        end
      end
    end

    unless hasTicket
      errors << "You must select at least 1 ticket"
    end

    errors
  end

  def order_params
    params.require(:order).permit(:first_name, :last_name, :address, :event_id)
  end

  def build_params
    result = {}
    result[:first_name] = params[:order][:first_name]
    result[:last_name] = params[:order][:last_name]
    result[:address] = params[:order][:address]
    result[:event_id] = params[:order][:event_id]

    @event.ticket_types.each do |type|
      result["quantity[#{type.id}]"] = params[:quantity]["#{type.id}"] if params[:quantity]["#{type.id}"]
    end

    result
  end
end