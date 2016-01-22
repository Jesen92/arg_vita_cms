class AddAttachmentAvatarToColors < ActiveRecord::Migration
  def self.up
    change_table :colors do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :colors, :avatar
  end
end
