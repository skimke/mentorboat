class RemoveNameFromUsers < ActiveRecord::Migration[5.1]
  def up
    remove_column :users, :name
  end

  def down
    add_column :users, :name, :string

    User.find_each do |user|
      full_name = "#{user.first_name} #{user.last_name}"

      user.update_attributes!(name: full_name)
    end
  end
end
