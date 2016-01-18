class OrderReceipt < BaseGrid

  scope do
    Order.includes(:inventory_items)
  end

  filter(:id, :integer)

  column(:id, header: "Order Number")
  column(:inventory_items, order: proc {|s|
    s.joins(:items).order('items.inventory_item_id')}) do |order|
    render 'shared/paginate_list', object: order.inventory_items,
                              locals: { class_name: "index in-table",
                                        in_table: true }
  end
  column(:total)
end