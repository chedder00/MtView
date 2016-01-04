module PlantsHelper

  def current_state(id)
    if(@state = PlantState.find_by(id: id))
      @state.name
    end
  end

  def cloned_from(id)
    Plant.find_by(id: id).serial_number
  end

  def parent_found?(id)
    @parent = Plant.find_by(id: id)
    if(@parent)
      return true
    else
      return false
    end
  end

  def set_heading(id)
    if(!id.nil? && @heading != id)
      @state = PlantState.find_by(id: id)
      @heading = id
      if(@state.name == "Mother")
        "<h1 class='section'>" + @state.name + "'s</h1>"
      else
        "<h1 class='section'>" + @state.name + "</h1>"
      end
    else
      return ""
    end
  end

end
