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

  #Should be called after a failed save because an entry for the item already
  #exists for the current order or task.  It will update the existing item
  #with this objects information
  def update_current
    if(update_existing?)
      #generate new quantity
      qty = @itm.quantity + self.quantity
      #update existing
      @itm.update_column(:quantity, qty)
      #if item belongs to an order update total
      if(!@itm.order.nil?)
        @parent.update_attributes(update_total: (self.quantity * 
                                               @itm.purchase_price_cents))
      end
      #remove quantity from inventory
      update_inventory(0-self.quantity)
      #set current item quantity to 0
      self.quantity = 0
      #update ids for routing purposes
      update_ids      
      return true
    end
    #ensures returning object can be routed properly
    update_ids
    return false
  end

  def sub_total
    ((self.quantity.to_f * self.purchase_price_cents.to_f) / 100).to_f
  end

################## PRIVATE METHODS #############################################
private
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
      #If returning a quantity check to make sure that return quantity
      #is less than what was allocated to task
      unless(self.quantity >= @check_value.to_i)
        return add_error(:return_quantity, 
                         "#{self.quantity} units allocated to task")
      end
    else
      #Check to make sure that the quantity requested is less than
      #current inventory stock
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
    #check current order items to see if item already exists
    if(@itm ||= @parent.items.find_by(inventory_item_id: self.inventory_item_id))
      return self.valid?
    end
    #mainly for routing, adds task and order id's to object 
    #before rejecting save
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
    #called before an item is destroyed so that the order can be updated
    #and the item's quantity is returned to stock
    if(order?)
      self.order.update_attributes(update_total: (0-(self.quantity.to_i * 
                                            self.purchase_price_cents.to_i)))
    end
    update_inventory(self.quantity)
  end

  def valid_return?(val)
    self.quantity >= val.to_i
  end

  def order?
    #if the termporany instance variable was set return true
    return true if !@order_number.nil?
    #if the existing item has an order return true
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

  #adds custom errors to current item
  def add_error(attrib, msg)
    self.errors.add(attrib, msg )
    return false
  end

  #used for routing object
  def update_ids
    self.task_id = @task_number
    self.order_id = @order_number
  end

  #ensures that the object is free from errors, not a return and already
  #exists in the current order or task
  def update_existing?
    !self.errors.any? && !item_return? && exists?
  end

end
