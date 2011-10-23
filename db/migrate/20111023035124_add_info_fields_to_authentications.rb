class AddInfoFieldsToAuthentications < ActiveRecord::Migration
  def self.up
    add_column :authentications, :name, :string
    add_column :authentications, :image, :string
    add_column :authentications, :desc, :text
    add_column :authentications, :original_auth, :text
  end

  def self.down
    remove_column :authentications, :original_auth
    remove_column :authentications, :desc
    remove_column :authentications, :image
    remove_column :authentications, :name
  end
end
