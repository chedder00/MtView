class PlantsController < ApplicationController

  before_action :administrator_access, only: [:new, :create, :destroy]
  before_action :staff_user

  def new
    @page_heading = "Add a Plant"
    @page_title = "New Plant"
    @btn_text = "Create Plant"
    @plant = Plant.new
    render 'shared/form'
  end

  def create
    @page_heading = "Add a Plant"
    @page_title = "New Plant"
    @btn_text = "Create Plant"
    @plant = Plant.new(plant_params)
    if(@plant.save)
      flash.now[:success] = "Record for #{@plant.name} created successfully"
      redirect_to @plant
    else
      render 'shared/form'
    end
  end

  def edit
    @page_title = "Edit Plant"
    @btn_text = "Update Plant"
    @plant = Plant.find(params[:id])
    @page_heading = "Edit #{@plant.name}"
    render 'shared/form'
  end

  def update
    @page_title = "Edit Plant"
    @btn_text = "Update Plant"
    @plant = Plant.find(params[:id])
    @page_heading = "Edit #{@plant.name}"
    if(@plant.update_attributes(plant_params))
      flash.now[:success] = "#{@plant.name} updated successfully"
      redirect_to @plant
    else
      render 'shared/form'
    end
  end

  def clone
    @clone = Clone.new
    @plant = Plant.find(params[:plant_id])
    @page_title = "Clone #{@plant.name}"
    @page_heading = "Cloning #{@plant.name}"
    @btn_text = "Clone #{@plant.name}"
  end

  def clone_create
    @clone = Clone.new(clone_params)
    if(@clone.valid?)
      @plant = Plant.find(params[:plant_id])
      @page_title = "Clone #{@plant.name}"
      @page_heading = "Cloning #{@plant.name}"
      @btn_text = "Clone #{@plant.name}"
      @clone.clone_qty.to_i.times do |c|
        c = Plant.new
        c.name = @plant.name
        c.species = @plant.species
        c.planting_date = @clone.clone_date
        c.cloned_from_id = @plant.id
        c.plant_state_id = PlantState.find_by(name: "Cloning").id
        c.save
      end
      redirect_to plants_path
    else
      render 'clone'
    end
  end

  def show
    @plant = Plant.find(params[:id])
    @page_heading = "#{@plant.name}"
  end

  def index
    @page_heading = "All Plants"
    @plants = Plant.paginate(page: params[:page])
  end

  def destroy
    Plant.find(params[:id]).destroy
    flash.now[:success] = "Plant deleted"
    redirect_to plants_path
  end

################## PRIVATE METHODS #############################################
private
  def plant_params
    if(admin?)
      params.require(:plant).permit(
        :name,
        :species,
        :planting_date,
        :harvest_date,
        :plant_state_id,
        :cloned_from_id
      )
    else
      params.require(:plant).permit(:harvest_date, :plant_state_id)
    end
  end

  def clone_params
    params.require(:clone).permit(:clone_date, :clone_qty)
  end
end
