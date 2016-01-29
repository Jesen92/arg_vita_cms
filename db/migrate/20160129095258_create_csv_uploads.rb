class CreateCsvUploads < ActiveRecord::Migration
  def change
    create_table :csv_uploads do |t|

      t.timestamps null: false
    end
  end
end
