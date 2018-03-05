class AddFirstAndLastNameToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    User.find_each do |user|
      names_arr = user.name.split(' ')

      user.update_attributes!(
        first_name: names_arr.first,
        last_name: names_arr.last
      )
    end
  end

  def down
    User.find_each do |user|
      first_name = user.first_name
      last_name = user.last_name

      user.update_attributes!(name: "#{first_name} #{last_name}")
    end

    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
