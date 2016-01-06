class ItemsController < ApplicationController

  before_action :staff_access, only: [:create, :destroy, 
                                      :return, :return_update], 
                                      unless: :reseller?

  def create
    if(params[:task_id].nil?)
      @order = Order.find(params[:order_id])
      @item = @order.items.build(item_params)
    else
      @task = Task.findZ(params[:task_id])
      @item = @task.items.build(item_params)
    end
    @inv_item = @item.inventory_item
    qty = params[:item][:quantity].to_i
    if(@inv_item.quantity >= qty)
      new_qty = @inv_item.quantity - qty
      if(@item.save)
        @inv_item.update_attributes(quantity: new_qty)
        flash[:success] = "Item added"
      end
    elsif(params[:item][:quantity].to_i > @inv_item.quantity)
      flash[:danger] = "Quantity must be less than or equal to #{@inv_item.quantity}"
    else
      flash[:danger] = "Quantity must be greater than 0"
    end
    redirect_to send_back
  end

  def return
    @item = Item.find(params[:item_id])
  end

  def return_update
    if(valid_return?)
      flash[:success] = "Retuned to stock"
      redirect_to send_back
    else
      flash.now[:danger] = 
        "Return quantity must be less than or equal to allocated quantity"
      render 'return'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    back_url = send_back
    @inv_item = @item.inventory_item
    new_qty = @inv_item.quantity + @item.quantity
    @inv_item.update_attributes(quantity: new_qty)
    @item.destroy
    flash[:success] = "Item removed"
    redirect_to back_url
  end

################## PRIVATE METHODS #############################################
private
  def item_params
    params.require(:item).permit(:task_id, :inventory_item_id, :quantity)
  end

  def return_params
    params.require(:item).permit(:return_quantity)
  end

  def valid_return?
    @item = Item.find(params[:item_id])
    new_qty = params[:item][:return_quantity]
    if(@item.quantity.to_i >= new_qty.to_i)
      @item.inventory_item.update_attributes(increase_qty: new_qty)
      @item.update_attributes(quantity: (@item.quantity - new_qty.to_i))
      @item.reload
      if(@item.quantity == 0)
        @item.destroy
      end
      return true
    end
    return false
  end

  def send_back
    if(@item.task_id.nil?)
      user_order_path(id: @item.order.id)
    else
      @task
    end
  end

end
