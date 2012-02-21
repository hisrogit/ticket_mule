class AddAdminToStatus < ActiveRecord::Migration
  def self.up
    add_column :statuses, :admin, :boolean,:default => false
  end

  def self.down
    remove_column :statuses, :admin
  end
end
