class FullTask < BaseGrid

  scope do
    Task.includes(:user, :plant, :items, :inventory_items)
  end

  filter(:user_id, :enum, header: "Assigned to user", 
         select: proc { User.staff.map {|u| [u.name, u.id]} })

  filter(:plant_id, :enum, header: "Assigned to plant",
    select: proc { Plant.all.map {|p| ["#{p.serial_number}-#{p.name}", p.id]} })

  filter(:updated_at, :date, header: "Date", range: true)

  column(:updated_at, header: "Date") do |note|
    note.updated_at.strftime(DATE_FORMAT)
  end
  
  column(:user, order: 'tasks.user_id', header: "Assigned to") do |u|
    if(!u.user.nil?)
      u.user.name
    end
  end

  column(:plant_name, order: 'tasks.plant_id', 
         header: "For plant") do |p|
    if(!p.plant.nil?)
      link_to "#{p.plant.serial_number} - #{p.plant.name}", p.plant
    end
  end

  column(:inventory_item_id, header: "Allocated Itemd", order: proc {|t| 
      t.scope.joins(:items).order('items.inventory_item_id')}) do |i|
    render 'shared/paginate_list', object: i.inventory_items, 
                                   locals: {class_name: "index slim",
                                            in_table: true } 
  end

end