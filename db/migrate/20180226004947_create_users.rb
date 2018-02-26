class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.column :name, :string
      t.column :position, :string
      t.column :company, :string
      t.column :experience_in_years, :integer, default: 0
      t.column :email, :string
    end
  end
end
