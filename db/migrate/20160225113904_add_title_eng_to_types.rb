class AddTitleEngToTypes < ActiveRecord::Migration
  def change
    add_column :types, :title_eng, :string
  end
end
