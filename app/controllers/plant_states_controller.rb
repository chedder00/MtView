class PlantStatesController < ApplicationController
  def new
    @plant_state = PlantState.new
    @page_title = "New Plant State"
    @page_heading = "Create new Plant State"
    @btn_text = "Create State"
    render 'shared/form'
  end

  def create
    @plant_state = PlantState.new(state_params)
    @page_title = "New Plant State"
    @page_heading = "Create new Plant State"
    @btn_text = "Create State"
    if(@plant_state.save)
      flash[:success] = "New state created"
      redirect_to new_plant_state_path
    else
      render 'shared/form'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
  end

  def show
  end

################## PRIVATE METHODS #############################################
private
  def state_params
    params.require(:plant_state).permit(:name, :state)
  end

end
