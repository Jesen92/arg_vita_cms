class AddAttachmentAvatarToSsubcategories < ActiveRecord::Migration
  def self.up
    change_table :ssubcategories do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :ssubcategories, :avatar
  end
end
