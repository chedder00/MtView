class PlantStatesController < ApplicationController

  before_action :administrator_access
  
  def new
    @plant_state = PlantState.new
    @page_title = "New Plant State"
    @page_heading = "Create new Plant State"
    @btn_text = "Add new State"
    render 'shared/form'
  end

  def create
    @plant_state = PlantState.new(state_params)
    @page_title = "New Plant State"
    @page_heading = "Create new Plant State"
    @btn_text = "Add new State"
    if(@plant_state.save)
      flash[:success] = "State: #{@plant_state.name} created successfully"
      redirect_to plant_states_path
    else
      render 'shared/form'
    end
  end

  def edit
    @plant_state = PlantState.find(params[:id])
    @page_title = @page_heading = "Edit #{@plant_state.name}"
    @btn_text = "Update #{@plant_state.name}"
    render 'shared/form'
  end

  def update
    @plant_state = PlantState.find(params[:id])
    @page_title = @page_heading = "Edit #{@plant_state.name}"
    @btn_text = "Update #{@plant_state.name}"
    if(@plant_state.update_attributes(state_params))
      flash[:success] = "#{@plant_state.name} updated"
      redirect_to plant_states_path
    else
      render 'shared/form'
    end
  end

  def destroy
    PlantState.find(params[:id]).destroy
    flash[:success] = "State removed"
    redirect_to root_url
  end

  def index
    @page_title = "All States"
    @page_heading = "All Plant States"
    @plant_states = PlantState.page(params[:page])
  end

################## PRIVATE METHODS #############################################
private
  def state_params
    params.require(:plant_state).permit(:name)
  end

end
