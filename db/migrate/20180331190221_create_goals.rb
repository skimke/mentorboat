class CreateGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :goals do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :relationship_id, :bigint

      t.timestamps null: false
    end

    add_index :goals, :title
    add_index :goals, :relationship_id
  end
end
