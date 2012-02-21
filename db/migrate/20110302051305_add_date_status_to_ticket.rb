class AddDateStatusToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :date_status, :date,:default => Time.now
  end

  def self.down
    remove_column :tickets, :date_status
  end
end
