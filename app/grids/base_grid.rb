class BaseGrid
  include Datagrid

  self.default_column_options = { :html => true }
  self.cached = true

    def counter
    @counter ||= 1
  end

  def counter=(val)
    @counter = val
  end

  def column_class(plant)
    self.counter = (self.counter.to_i + 1)
    if(self.counter%2 == 0)
      "odd"
    else
      "even"
    end
  end
end