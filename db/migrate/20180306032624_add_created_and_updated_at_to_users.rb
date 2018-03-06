class AddCreatedAndUpdatedAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_timestamps :users, default: Time.zone.now
  end
end
