class ItemsController < ApplicationController

  def create
    #debugger
    @item = Item.new(item_params)
    @item.order_number = params[:order_id]
    @item.task_number = params[:task_id]
    if(@item.save)
      flash[:success] = "Item added"
    else
      if(@item.update_current)
        flash[:success] = "Quantity added to existing item"
      end
      back_url = send_back
      if(!@item.errors.any? && @item.quantity == 0)
        @item.destroy
        redirect_to back_url
        return
      else
        flash[:danger] = @item.errors if @item.errors.any?
      end
    end
    redirect_to send_back
  end

  def return
    @item = Item.find(params[:item_id])
  end

  def return_update
    @item = Item.find(params[:item_id])
    @item.return_quantity = params[:item][:return_quantity]
    @item.task_number = params[:task_id]
    @item.order_number = params[:order_id]
    back_url = send_back
    if(@item.update_attributes(item_params))
      flash[:success] = "Retuned to stock"
      @item.destroy if (@item.quantity == 0)
      redirect_to back_url
      return
    else
      render 'return'
    end    
  end

  def show
    @item = Item.find(params[:id])
    @page_heading = "#{@item.inventory_item.name}"
  end

  def destroy
    @item = Item.find(params[:id])
    back_url = send_back
    @item.destroy
    flash[:success] = "Item removed"
    redirect_to back_url
  end

################## PRIVATE METHODS #############################################
private
  def item_params
    params.require(:item).permit(:inventory_item_id, :quantity)
  end

  def return_params
    params.require(:item).permit(:return_quantity)
  end

  def send_back
    if(@item.task.nil?)
      user_order_path(user_id: current_user.id, id: @item.order.id)
    else
      task_path(id: @item.task.id)
    end
  end

end
