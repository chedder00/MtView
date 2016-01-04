class NotesController < ApplicationController
  
  before_action :staff_access
  before_action :administrator_access, only: :destroy

  def new
    @page_title = "New Note"
    @page_heading = "Create a Note"
    @btn_txt = "Create Note"
    page_init
    if(@user)
      @note = @user.notes.new
    elsif (@plant)
      @note = @plant.notes.new
    elsif (@item)
      @note = @item.notes.new
    end      
    render 'shared/form'
  end

  def create
    @page_title = "New Note"
    @page_heading = "Create a Note"
    @btn_txt = "Create Note"
    page_init
    if(@user)
      @note = @user.notes.new(note_params)
    elsif (@plant)
      @note = @plant.notes.new(note_params)
    elsif (@item)
      @note = @item.notes.new(note_params)
    end      
    if(@note.save)
      flash[:success] = "Note created"
      if(@plant)
        redirect_to @plant
      elsif(@item)
        redirect_to @item
      else
        redirect_to root_url
      end          
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
    @page_title = @page_heading = "Edit Note"
    @btn_txt = "Update Note"
    @note = Note.find(params[:id])
    if(@note.update_attributes(note_params))
      flash[:success] = "Note update"
      if(@plant)
        redirect_to @plant
      elsif(@item)
        redirect_to @item
      else
        redirect_to root_url
      end
    else
      render 'shared/form'
    end
  end

  def destroy
    Note.find(params[:id]).destroy
    flash[:success] = "Note destroyed"
    redirect_to root_url
  end

  def show
    @note = Note.find(params[:id])
  end

  def index
    @page_title = @page_heading = "All Notes"
    page_init
    if(@user)
      @notes = @user.notes.paginate(page: params[:page])
    elsif(@plant)
      @notes = @plant.notes.paginate(page: params[:page])
    elsif(@item)
      @notes = @item.notes.paginate(page: params[:page])
    else
      @notes = Note.paginate(page: params[:page])
    end
  end

################## PRIVATE METHODS #############################################
private
  def note_params
    params.require(:note).permit(:message, :user_id, 
                                 :plant_id, :inventory_item_id, :closed)
  end

  def page_init
    @user = User.find_by(id: params[:user_id])
    @plant = Plant.find_by(id: params[:plant_id])
    @item = InventoryItem.find_by(id: params[:inventory_item_id])
  end

end
