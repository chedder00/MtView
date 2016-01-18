class FullItem < BaseGrid

  scope do
    InventoryItem.includes(:notes)
  end

  filter(:id, :integer)

  filter(:name, :string) do |value|
    where("name LIKE '%#{value}%'")
  end

  filter(:resale_only, :boolean, checkbox: true) do |val|
    where('avaliable_to_reseller=?', (val==0)? false : true)
  end

  column_names_filter(header: "Column", checkboxes: true)

  column(:name)
  column(:quantity)
  column(:notes, order: 'notes.updated_at', html: true) do |item|
    render 'shared/paginate_list', object: item.notes, 
                              locals: { class_name: "index in-table",
                                        in_table: true }
  end

  column(:price, order: 'inventory_items.price_cents', 
         header: "Retail Price", html:true) do |item|
    humanized_money_with_symbol(item.price)
  end

  column(:suggested_retail_price, 
         order: 'inventory_items.suggested_retail_price_cents', 
         header: "Suggested Retail Price", html:true) do |item|
    if(item.suggested_retail_price == 0)
      "Not for resale"
    else
      humanized_money_with_symbol(item.suggested_retail_price)
    end
  end

end