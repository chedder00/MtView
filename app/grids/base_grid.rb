class BaseGrid
  include Datagrid

  self.default_column_options = { :html => true }
  self.cached = true
end