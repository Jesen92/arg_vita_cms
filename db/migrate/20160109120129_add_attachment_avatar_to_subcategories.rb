class AddAttachmentAvatarToSubcategories < ActiveRecord::Migration
  def self.up
    change_table :subcategories do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :subcategories, :avatar
  end
end
