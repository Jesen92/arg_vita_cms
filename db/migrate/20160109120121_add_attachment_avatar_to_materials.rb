class AddAttachmentAvatarToMaterials < ActiveRecord::Migration
  def self.up
    change_table :materials do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :materials, :avatar
  end
end
