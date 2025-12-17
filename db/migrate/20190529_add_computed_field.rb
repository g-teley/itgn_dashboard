class AddComputedField < ActiveRecord::Migration[7.1]
  def change
    add_column :itgn_dashboard_setups, :computed_field, :integer
  end
end
