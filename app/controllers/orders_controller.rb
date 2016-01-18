class OrdersController < ApplicationController

  before_action :reseller, only: [:create, :show, :destroy] 
  before_action :administrator_access, only: [:edit, :update, :index]
  before_action :correct_user, only: :destroy

  def create
    @order = current_user.orders.build(user_id: current_user.id)
    if(@order.save)
      redirect_to user_order_path(user_id: current_user.id,
                                  id: @order.id)
    end
  end

  def edit
    @order = Order.find(params[:id])
    @page_title = "Order #{@order.id}"
    @page_heading = "Edit " + @page_title
    @btn_text = "Update order #{@order.id}"
    render 'shared/form'
  end

  def update
    @order = Order.find(params[:id])
    if(@order.update_attributes(order_params))
      flash[:success] = "Order updated"
      redirect_to root_url
    else
      render 'shared/form'
    end
  end

  def destroy
    Order.find(params[:id]).destroy
    flash[:success] = "Order deleted"
    redirect_to root_url
  end

  def index
    @page_title = @page_heading = "All Orders"
    @orders = Order.current.page(params[:page])
    @submitted = Order.history.page(params[:page])
    @closed = Order.closed.page(params[:page])
  end

  def show 
    @order = Order.find(params[:id])
    @page_title = "Order: #{@order.id}"
    @page_heading = @page_title + " for #{@order.user.name}"
    @btn_text = "Add to order"
    @item = @order.items.build
    @items = @order.items.page(params[:page]).per(5)
    @avaliable = InventoryItem.resale.page(params[:page]).per(10)
  end

  def submit
    @order = current_user.orders.find(params[:order_id])
    @order.update_attributes(submitted: true)
    #TODO: send emails
    redirect_to root_url
  end

################## PRIVATE METHODS #############################################
private
  def order_params
    params.require(:order).permit(:completed) if(administrator?)
  end

  def correct_user
    unless current_user.administrator?
      user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(user)
    end
  end

  def reseller
    unless current_user.administrator?
      return current_user.reseller?(true)
    end
  end

end
