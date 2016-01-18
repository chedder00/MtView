class FullPlant < BaseGrid

  scope do
    Plant.includes(:plant_state, :notes, :tasks)
  end

  filter(:id, :integer)

  filter(:serial_number, :enum, select: scope.pluck(:serial_number))

  filter(:plant_state_id, :enum, header: 'State',
         select: proc { PlantState.all.map {|s| [s.name, s.id]} })

  filter(:species, :string)

  filter(:planting_date, :date, range: true)

  filter(:harvest_date, :date, range: true)

  column(:serial_number)

  column(:name, html: true) do |p|
    link_to p.name, p
  end

  column(:species)

  column(:plant_state_name, order: 'plants.id', header: "State") 

   column(:planting_date) do |plant|
     plant.planting_date.strftime(DATE_FORMAT)
   end

  column(:harvest_date) do |plant|
    plant.planting_date.strftime(DATE_FORMAT)
  end

  column(:notes, order: 'notes.plant_id', html: true) do |p|
    link_to p.notes.count, plant_notes_path(p)
  end

  column(:tasks, order: 'tasks.plant_id', html: true) do |p|
    link_to p.tasks.count, plant_tasks_path(p)
  end

end