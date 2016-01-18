class FullOrder < BaseGrid

  scope do
    Order.includes(:inventory_items)
  end

  filter(:id, :integer)

  filter(:order_number, :integer) do |val|
    where("id=?",val)
  end

  filter(:submitted, :xboolean)

  column(:order_number, order: 'order.id', html: true) do |ord|
    link_to ord.id, user_order_path(user_id: ord.user.id, id: ord.id)
  end
  
  column(:inventory_items, order: proc {|s|
      s.joins(:items).order('items.inventory_item_id')}) do |order|
    render 'shared/paginate_list', object: order.inventory_items,
                              locals: { class_name: "index in-table",
                                        in_table: true }
  end

  column(:subtotal, order: proc {|s| 
    s.joins(:items).order('items.inventory_item_id')}) do |order|
    render 'shared/paginate_list', object: order.items,
                                   locals: { class_name: "index in-table",
                                             in_table: true }
  end

  column(:total)

end