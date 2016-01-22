class AddStartDateAndEndDateToComplements < ActiveRecord::Migration
  def change
    add_column :complements, :start_date, :datetime
    add_column :complements, :end_date, :datetime
  end
end
