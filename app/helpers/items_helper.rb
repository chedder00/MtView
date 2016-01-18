module ItemsHelper

  def link_path(item)
    if(order?(item))
      order_item_path(id: item.id, order_id: item.order.id)
    else
      inventory_item_path(item.inventory_item_id)
    end
  end

  def checkbox_display(item)
    if(!@item.order.nil?)
      "#{item.name} - #{humanized_money_with_symbol(item.price)}"
    else
      "#{item.name} - Avaliable Quantity: #{item.quantity}"
    end
  end

  def order?(item)
    !item.order.nil?
  end

end
