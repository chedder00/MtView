class Item < ActiveRecord::Base
  
  attr_accessor :return_quantity
  attr_reader :sub_total
  attr_accessor :order_number
  attr_accessor :task_number

  belongs_to :task
  belongs_to :order
  belongs_to :inventory_item

  before_save :validate_item
  after_create :update_order
  after_save :return_item

  before_destroy :remove_item

  validates :quantity, numericality: { greater_than: 0 }, on: :create
  validates :return_quantity, numericality: { greater_than: 0 }, 
            on: :return_update

  monetize :purchase_price_cents
  monetize :sub_total
  
  def return_quantity
    @return_quantity
  end

  def return_quantity=(val)
    @return_quantity = val
  end

  def order_number=(val)
    @order_number = val
  end

  def task_number=(val)
    @task_number = val
  end

  def set_purchase_price
    self.purchase_price_cents = self.inventory_item.price_cents
  end

  def validate_item
    @check_value ||= (item_return?)? @return_quantity : self.quantity
    if(valid_quantity?)
      if(!exists?)
        set_purchase_price
        update_inventory(0-self.quantity)
        return true
      end
      return true if item_return?
    end
    return false
  end

  def valid_quantity?
    if(self.quantity == 0)
      return add_error(:quantity, "Must be greater than 0")
    elsif item_return?
      unless(self.quantity >= @check_value.to_i)
        return add_error(:return_quantity, 
                         "#{self.quantity} units allocated to task")
      end
    else
      unless(@check_value.to_i <= self.inventory_item.quantity)
        return add_error(:quantity,
              "must be less than or equal to #{self.inventory_item.quantity}")
      end
    end
    return true
  end

  def exists?
    if(order?)
      @parent ||= Order.find(@order_number)
      #return error if order has been submitted
      return add_error(:id, "Closed") if @parent.submitted?
    else
      @parent ||= Task.find(@task_number)
    end
    if(@itm ||= @parent.items.find_by(inventory_item_id: self.inventory_item_id))
      return self.valid?
    end
    update_ids
    return false
  end

  def update_order
    if(order?)
      total = self.quantity.to_i * self.purchase_price_cents.to_i
      self.order.update_attributes(update_total: total)
    end
  end

  def return_item
    if(item_return?)
      update_inventory(@return_quantity)
      self.update_column(:quantity, (self.quantity - @return_quantity.to_i))
    end
  end

  def update_inventory(qty)
    self.inventory_item.update_attributes(increase_qty: qty)
  end

  def remove_item
    if(order?)
      self.order.update_attributes(update_total: (0-(self.quantity.to_i * 
                                            self.purchase_price_cents.to_i)))
    end
    update_inventory(self.quantity)
  end
  
  def sub_total
    ((self.quantity.to_f * self.purchase_price_cents.to_f) / 100).to_f
  end

  def update_current
    if(update_existing?)
      qty = @itm.quantity + self.quantity
      @itm.update_column(:quantity, qty)
      if(!@itm.order.nil?)
        @parent.update_attributes(update_total: (self.quantity * 
                                               @itm.purchase_price_cents))
      end
      self.quantity = 0
      update_inventory(0-self.quantity)
    end
    update_ids
  end

  def valid_return?(val)
    self.quantity >= val.to_i
  end

  def order?
    return true if !@order_number.nil?
    if(!self.order.nil?)
      @order_number = self.order.id
      return true
    end
    return false
  end

  def item_return?
    return true if !@return_quantity.nil?
    return false
  end

  def add_error(attrib, msg)
    self.errors.add(attrib, msg )
    return false
  end

  def update_ids
    self.task_id = @task_number
    self.order_id = @order_number
  end

  def update_existing?
    !self.errors.any? && !item_return? && exists?
  end

end
