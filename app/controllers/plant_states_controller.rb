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
  end

  def update
  end

  def destroy
  end

  def index
    @page_title = "Plant States"
    @plant_states = PlantState.paginate(page: params[:page])
  end

  def show
  end

################## PRIVATE METHODS #############################################
private
  def state_params
    params.require(:plant_state).permit(:name)
  end

end
