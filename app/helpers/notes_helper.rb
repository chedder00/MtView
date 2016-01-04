module NotesHelper

  def note_path(note)
    if(!note.user_id.nil?)
      user_note_path(id: note.id, user_id: note.user_id)
    elsif(!note.plant_id.nil?)
      plant_note_path(id: note.id, plant_id: note.plant_id)
    elsif(!note.inventory_item_id.nil?)
      inventory_item_note_path(id: note.id, 
                               inventory_item_id: note.inventory_item_id)
    end
  end
end
