class PlantsController < ApplicationController

  respond_to :html, :json

  before_action :staff_access
  before_action :administrator_access, only: [:new, :create, :destroy]

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
      flash[:success] = "Record for #{@plant.name} created successfully"
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
      flash[:success] = "#{@plant.name} updated successfully"
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
      state = PlantState.find_by_name("Cloning").id
      @plant = Plant.find(params[:plant_id])
      @clone.clone_qty.to_i.times do |c|
        c = Plant.new
        c.name = @plant.name
        c.species = @plant.species
        c.planting_date = @clone.clone_date
        c.cloned_from_id = @plant.id
        c.plant_state_id = state
        c.save
      end
      redirect_to plants_path
    else
      render 'clone'
    end
  end

  def show
    @plant = Plant.find(params[:id])
    @page_title = @page_heading = "#{@plant.name}"
    @task = @plant.tasks.new
    @tasks = @plant.tasks.page(params[:page]).per(5)
    @notes = @plant.notes.page(params[:page]).per(5)
    @measurement = @plant.measurements.last
    @response = { plant: @plant, tasks: @task, notes: @notes }
    respond_with @response
  end

  def index
    @page_title = @page_heading = "All Plants"
    @plants = Plant.state.page(params[:page])
  end

  def destroy
    #debugger
    Plant.find(params[:id]).destroy
    flash[:success] = "Plant deleted"
    redirect_to plants_path
  end

################## PRIVATE METHODS #############################################
private
  def plant_params
    if(current_user.administrator?)
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

  def generate_serial_number(plant)
    plant.name[0..2].upcase + plant.planting_date.strftime("%m%d%y") + plant.id.to_s
  end
end
