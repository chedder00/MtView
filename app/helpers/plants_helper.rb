module PlantsHelper

  def current_state(id)
    if(@state = PlantState.find_by(id: id))
      @state.name
    end
  end

  def cloned_from(id)
    if(@cloned = Plant.find_by(id: id))
      @cloned.name
    end
  end
  
end
