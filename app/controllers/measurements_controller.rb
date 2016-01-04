class MeasurementsController < ApplicationController

  def new
    @page_title = "New Measurement"
    @plant = Plant.find(params[:plant_id])
    @page_heading = "New measurement for #{@plant.name}"
    @btn_text = "Add Measurement"
    @measurement = @plant.measurements.new
    render 'shared/form'
  end

  def create
    @page_title = "New Measurement"
    @plant = Plant.find(params[:plant_id])
    @page_heading = "New measurement for #{@plant.name}"
    @btn_text = "Add Measurement"
    @measurement = @plant.measurements.new(measurement_params)
    if(@measurement.save)
      flash[:success] = "Measurement Added"
      redirect_to @plant
    else
      render 'shared/form'
    end
  end

  def edit
    @page_title = "Edit Measurement"
    @plant = Plant.find(params[:plant_id])
    @page_heading = "Edit measurement for #{@plant.name}"
    @btn_text = "Update Measurement"
    @measurement = @plant.measurements.find(params[:id])
    render 'shared/form'
  end

  def update
    @page_title = "Edit Measurement"
    @plant = Plant.find(params[:plant_id])
    @page_heading = "Edit measurement for #{@plant.name}"
    @btn_text = "Update Measurement"
    @measurement = @plant.measurements.find(params[:id])
    if(@measurement.update_attributes(measurement_params))
      flash[:success] = "Measurement Updated"
      redirect_to @plant
    else
      render 'shared/form'
    end
  end

  def destroy
    Measurement.find(params[:id]).destroy
    flash[:success] = "Measurement Deleted"
    redirect_to root_url
  end

################## PRIVATE METHODS #############################################
private
  def measurement_params
    params.require(:measurement).permit(:base, :height)
  end

end
