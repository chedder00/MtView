class NotesController < ApplicationController
  
  before_action :staff_access
  before_action :administrator_access, only: :destroy
  before_action :page_init, only: [:new, :create, :index]

  def new
    @page_title = "New Note"
    @page_heading = "Create a Note"
    @btn_txt = "Create Note"
    @note = @parent.notes.new
    render 'shared/form'
  end

  def create
    @note = @parent.notes.new(note_params)
    if(@note.save)
      flash[:success] = "Note created"
      redirect_to send_back 
    else
      render 'shared/form'
    end
  end

  def edit
    @page_title = @page_heading = "Edit Note"
    @btn_txt = "Update Note"
    @note = Note.find(params[:id])
    render 'shared/form'
  end

  def update
    @note = Note.find(params[:id])
    if(@note.update_attributes(note_params))
      flash[:success] = "Note update"
      redirect_to send_back
    else
      render 'shared/form'
    end
  end

  def destroy
    @note = Note.find(params[:id])
    back_url = send_back
    @note.destroy
    flash[:success] = "Note destroyed"
    redirect_to back_url
  end

  def show
    @note = Note.find(params[:id])
  end

  def index
    @page_title = @page_heading = "All Notes"
    @notes = @parent.notes.page(params[:page])
  end

################## PRIVATE METHODS #############################################
private
  def note_params
    params.require(:note).permit(:message, :user_id, 
                                 :plant_id, :inventory_item_id, :closed)
  end

  def page_init
    if(!@parent = User.find_by(id: params[:user_id]))
      if(!@parent = Plant.find_by(id: params[:plant_id]))
        @parent = InventoryItem.find_by(id: params[:inventory_item_id])
      end
    end
  end

  def send_back
    if(!@note.plant.nil?)
      return plant_path(@note.plant)
    elsif(!@note.inventory_item.nil?)
      return inventory_item_path(@note.inventory_item)
    end
    return root_url
  end

end
