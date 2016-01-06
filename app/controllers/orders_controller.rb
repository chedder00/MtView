class OrdersController < ApplicationController

  before_action :reseller?, only: [:create, :show, :destroy], unless: :admin?
  before_action :administrator_access, only: [:edit, :update, :index]
  before_action :correct_user, only: [:destroy]

  def create
    @order = current_user.orders.build(user_id: current_user.id)
    if(@order.save)
      redirect_to user_order_path(user_id: current_user.id,
                                  id: @order.id)
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @order = @user.orders.find(params[:id])
    @page_title = "Order #{@order.id}"
    @page_heading = "Edit " + @page_title
    @btn_text = "Update order #{@order.id}"
    render 'shared/form'
  end

  def update
    @user = User.find(params[:user_id])
    @order = @user.find(params[:id])
    if(@order.udpate_attributes(order_params))
      flash[:success] = "Order updated"
      redirect_to root_url
    else
      render 'shared/form'
    end
  end

  def destroy
    @user.orders.find(params[:id]).destroy
    flash[:success] = "Order deleted"
    redirect_to root_url
  end

  def index
    @page_title = @page_heading = "All Orders"
    @orders = Order.open.paginate(page: params[:page])
  end

  def show    
    @order = Order.find(params[:id])
    @page_title = "Order: #{@order.id}"
    @page_heading = @page_title + " for #{@order.user.name}"
    @item = @order.items.build
    @items = @order.items.paginate(page: params[:page])
    @avaliable = InventoryItem.resale
  end

################## PRIVATE METHODS #############################################
private
  def order_params
    params.require(:order).permit(:user_id, :total, :completed) if(admin?)
  end

  def correct_user
    unless admin?
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end
  end

end
