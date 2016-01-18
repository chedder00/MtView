class ReportsController < ApplicationController

  before_action :staff_access, expect: [:full_order, :order_receipt]
  before_action :administrator_access, only: :full_order
  before_action :correct_user, only: [:order_receipt]

  def new
    redirect_to root_url
  end

  def full_user
    params[:full_user] = { id: params[:id] } if params[:full_user].nil?
    @grid = FullUser.new(params[:full_user]) do |scope|
      scope.page(params[:page])
    end
    respond("User Report", "Landscape")
  end

  def full_plant
    params[:full_plant] = {id: params[:id]} if params[:full_plant].nil?
    @grid = FullPlant.new(params[:full_plant]) do |scope|
      scope.page(params[:page])
    end
    respond("Plant Report")
  end

  def full_note 
    params[:full_note] = {
                            user_id: params[:user_id],
                            plant_id: params[:plant_id],
                            inventory_item_id: params[:inventory_item_id]
                          } if params[:full_note].nil?

    @grid = FullNote.new(params[:full_note]) do |scope|
      scope.page(params[:page])
    end
    respond("Note Report")
  end

  def full_task
    params[:full_task] = {user_id: params[:user_id],
                         plant_id: params[:plant_id]} if params[:full_task].nil?
    @grid = FullTask.new(params[:full_task]) do |scope|
      scope.page(params[:page])
    end
    respond("Task Report")
  end

  def full_item
    params[:full_item] = {id: params[:id] } if params[:full_item].nil?
    @grid = FullItem.new(params[:full_item]) do |scope|
      scope.page(params[:page])
    end
    respond("Item Report")
  end

  def full_order
    params[:full_order] = { id: params[:id] } if params[:full_order].nil?
    @grid = FullOrder.new(params[:full_order]) do |scope|
      scope.page(params[:page])
    end
    respond("Item Report")
  end

  def order_receipt
    params[:order_receipt] = { id: params[:id] }
    @grid = OrderReceipt.new(params[:order_receipt]) do |scope|
      scope.page(params[:page])
    end
    request.format = 'pdf'
    respond("Receipt")
  end

################## PRIVATE METHODS #############################################
private
  #redirects output to correct format
  def respond(filename=nil, orientation="Portrait")
    respond_to do |f|
      f.html do
        @grid.scope { |scope| scope.page(params[:page]) }
        render 'reports/_report'
      end
      f.csv do
        send_data @grid.to_csv,
          type: 'text/csv',
          disposition: 'inline',
          filename: "#{filename.underscore}_#{Time.now.to_s}"
      end
      f.json do
        send_data @grid.scope.to_json,
          type: 'text/json',
          disposition: 'inline'
        return
      end
      f.pdf do
        render pdf: "#{filename.underscore}_#{Time.now.to_s}",
               template: 'reports/_report.pdf.erb',
               header: { right: '[page] of [topage]' },
               orientation: orientation,
               show_as_html: params.key?('debug')
      end
    end
  end

  def correct_user
    if(order = Order.find_by(id: params[:id]))
      unless(current_user.administrator?)
        unless(current_user?(order.user))
          flash[:danger] = "Unauthorized Action"
          redirect_to root_url
        end
      end
    else
      return false
    end
  end

end