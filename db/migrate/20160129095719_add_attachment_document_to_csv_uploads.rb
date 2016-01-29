class AddAttachmentDocumentToCsvUploads < ActiveRecord::Migration
  def self.up
    change_table :csv_uploads do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :csv_uploads, :document
  end
end
