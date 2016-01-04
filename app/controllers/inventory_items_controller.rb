class InventoryItemsController < ApplicationController

  before_action :administrator_access, only: [:new, :create, :destroy]
  before_action :inventory_controller_access, except: [:show, :index]
  before_action :logged_in_user, only: [:show, :index]

  def new
    @page_title = "New Inventory Item"
    @page_heading = "Add Inventory Item"
    @btn_text = "Create Item"
    @item = InventoryItem.new
    render 'shared/form'
  end

  def create
    @page_title = "New Inventory Item"
    @page_heading = "Add Inventory Item"
    @btn_text = "Create Item"
    @item = InventoryItem.new(item_params)
    if(@item.save)
      flash[:success] = "Item created successfully"
      redirect_to new_inventory_item_path
    else
      render 'shared/form'
    end
  end

  def edit
    @page_title = "Edit Inventory Item"    
    @item = InventoryItem.find(params[:id])
    @page_heading = "Edit #{@item.name}"
    @btn_text = "Update #{@item.name}"
    render 'shared/form'
  end

  def update
    @page_title = "Edit Inventory Item"    
    @item = InventoryItem.find(params[:id])
    @page_heading = "Edit #{@item.name}"
    @btn_text = "Update #{@item.name}"
    if(@item.update_attributes(item_params))
      flash[:success] = "#{@item.name} updated"
      redirect_to inventory_items_path
    else
      render 'shared/form'
    end
  end

  def show
    @item = InventoryItem.find(params[:id])
    @page_title = @page_heading = @item.name
    @notes = @item.notes.paginate(page: params[:page])
  end

  def index
    @page_title = @page_heading = "All Inventory Items"
    @inventory_items = InventoryItem.paginate(page: params[:page])
  end

  def destroy
    InventoryItem.find(params[:id]).destroy
    flash.now[:success] = "Item deleted"
    redirect_to inventory_items_path
  end

################## PRIVATE METHODS #############################################
private

  def item_params
    if(controller?)
      params.require(:inventory_item).permit( :name, 
                                              :avaliable_to_reseller,
                                              :increase_qty,
                                              :new_price )
    elsif(admin?)
      params.require(:inventory_item).permit( :name, 
                                              :avaliable_to_reseller,
                                              :increase_qty )
    else
      params.require(:inventory_item).permit( :increase_qty )
    end
  end

end
