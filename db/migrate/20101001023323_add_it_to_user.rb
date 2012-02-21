class AddItToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :it, :boolean,:default => false
  end

  def self.down
    remove_column :users, :it
  end
end
