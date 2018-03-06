class AddWillingToMentorAndIsApprovedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :willing_to_mentor, :boolean, default: false
    add_column :users, :is_approved, :boolean, default: false
  end
end
