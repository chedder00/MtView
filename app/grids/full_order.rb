class FullOrder < BaseGrid

  scope do
    Order.includes(:inventory_items)
  end

  filter(:id, :integer)

  filter(:order_number, :integer) do |val|
    where("id=?",val)
  end

  filter(:submitted, :xboolean)

  filter(:completed, :xboolean)

  column(:order_number, order: 'order.id', html: true) do |ord|
    link_to ord.id, user_order_path(user_id: ord.user.id, id: ord.id)
  end
  
  column(:inventory_items, order: 'orders.id') do |order|
    render 'shared/paginate_list', object: order.inventory_items,
                              locals: { class_name: "index in-table",
                                        in_table: true }
  end

  column(:subtotal) do |order|
    render 'shared/paginate_list', object: order.items,
                                   locals: { class_name: "index in-table",
                                             in_table: true }
  end

  column(:total) do |order|
    humanized_money_with_symbol(order.total)
  end

end