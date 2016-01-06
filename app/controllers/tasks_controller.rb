class TasksController < ApplicationController

  before_action :staff_access, except: :destroy
  before_action :administrator_access, only: :destroy

  def new
    @page_title = "New Task"
    @page_heading = "Create new Task"
    @btn_text = "Create Task"
    @plant = Plant.find_by(id: params[:plant_id])
    if(@plant)
      @task = Plant.find(params[:plant_id]).tasks.new
    else
      @task = Task.new
    end
    render 'shared/form'
  end

  def create
    @page_title = "New Task"
    @page_heading = "Create new Task"
    @btn_text = "Create Task"
    @plant = Plant.find_by(id: params[:plant_id])
    if(@plant) 
      @task = @plant.tasks.new(task_params)
    else
      @task = Task.new(task_params)
    end
    if(@task.save)
      flash[:success] = "Task Created"
      if(@plant)
        redirect_to @plant
      else
        redirect_to @task
      end
    else
      render 'shared/form'
    end
  end

  def edit
    @page_title = "Edit Task"
    @plant = Plant.find_by(id: params[:plant_id])
    @task = Task.find(params[:id])
    @page_heading = "Edit #{@task.name}"
    @btn_text = "Update #{@task.name}"
    render 'shared/form'
  end

  def update
    @page_title = "Edit Task"
    @plant = Plant.find_by(id: params[:plant_id])
    @task = Task.find(params[:id])
    @page_heading = "Edit #{@task.name}"
    @btn_text = "Update #{@task.name}"
    if(@task.update_attributes(task_params))
      flash[:success] = "#{@task.name} updated"
      if(@plant)
        redirect_to @plant
      else
        redirect_to root_url
      end
    else
      render 'shared/form'
    end
  end

  def show
    @plant = Plant.find_by(id: params[:plant_id])
    @task = Task.find(params[:id])
    @page_title = @page_heading = "#{@task.name}"
    @item = @task.items.build
    @items = @task.items.all
    @avaliable = InventoryItem.all
  end

  def index
    @user = User.find_by(id: params[:user_id])
    @plant = Plant.find_by(id: params[:plant_id])
    @page_title = "All Tasks"
    if(@user)
      @page_heading = "Tasks for #{@user.name}"
      @tasks = @user.tasks.paginate(page: params[:page])
    elsif(@plant)
      @page_heading = "Tasks for #{@plant.name}"
      @tasks = @plant.tasks.paginate(page: params[:page])
    else
      @page_heading = "#{@page_title}"
      @tasks = Task.paginate(page: params[:page])
    end
  end

  def destroy
    @task = Task.find(params[:id])
    plant_id = @task.plant_id
    @task.destroy
    flash[:success] = "Task deleted"
    if(!plant_id.nil?)
      redirect_to plant_path(plant_id)
    else
      redirect_to root_url
    end
  end

################## PRIVATE METHODS #############################################
private

  def task_params
    params.require(:task).permit( :name, :description, :plant_id, :user_id )
  end

end
