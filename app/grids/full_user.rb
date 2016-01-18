class FullUser < BaseGrid

  scope do 
    User.includes(:tasks, :notes)    
  end

  filter(:id, :integer)
  
  filter(:activated, :xboolean, default: "Yes")
  
  filter(:name, :string) do |value|
    self.where("name LIKE '%#{value}%'")
  end

  filter(:email, :string) do |value|
    self.where("email LIKE '%#{value}%'")
  end

  filter(:hire_date, :date, range: true)

  filter(:termination_date, :date, range: true)

  filter(:address, :string) do |value|
    self.where("address LIKE '%#{value}%' OR address2 LIKE '%#{value}%'")
  end

  filter(:city, :string) do |value|
    self.where("city LIKE '%#{value}%'")
  end

  filter(:state, :string) do |value|
    self.where("state LIKE '%#{value}%'")
  end

  filter(:zipcode, :string) do |value|
    self.where("zipcode LIKE '%#{value}%'")
  end

  filter(:phone_number, :string) do |value|
    self.where("phone_number LIKE '%#{value}%'")
  end

  column_names_filter(header: "Restrict Column Display", checkboxes: true)

  column(:activated) { (activated?)? "Yes" : "No" }
  column(:name)
  column(:role) do |user|
    user.role.name
  end
  column(:email)
  column(:hire_date)
  column(:termination_date)
  column(:address)
  column(:address2)
  column(:city)
  column(:state)
  column(:zipcode)
  column(:phone_number)
end