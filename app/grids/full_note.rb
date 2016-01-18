class FullNote < BaseGrid

  scope do
    Note.includes(:user, :plant, :inventory_item)
  end

  filter(:user_id, :enum, header: "Assigned to user", 
         select: proc { User.staff.map {|u| [u.name, u.id]} })

  filter(:plant_id, :enum, header: "Assigned to plant",
    select: proc { Plant.all.map {|p| ["#{p.serial_number}-#{p.name}", p.id]} })

  filter(:inventory_item_id, :enum, header: "Assigned to item",
    select: proc { InventoryItem.all.map {|i| [i.name, i.id]} })

  filter(:updated_at, :date, header: "Date", range: true)

  filter(:message, :string) do |value|
    self.where("message LIKE '%#{value}%'")
  end

  column(:updated_at, header: "Date") do |note|
     link_to note.updated_at.strftime(DATE_FORMAT), note
  end
  
  column(:user, order: 'notes.user_id', header: "For User") do |u|
    if(!u.user.nil?)
      u.user.name
    end
  end

  column(:plant_name, order: 'notes.plant_id', header: "For Plant") do |p|
    if(!p.plant.nil?)
      link_to "#{p.plant.serial_number} - #{p.plant.name}", p.plant
    end
  end

  column(:inventory_item_name, order: 'notes.inventory_item_id', 
         header: "For Item") do |i|
    if(!i.inventory_item.nil?)
      link_to i.inventory_item.name, i.inventory_item
    end
  end

  column(:message)

end