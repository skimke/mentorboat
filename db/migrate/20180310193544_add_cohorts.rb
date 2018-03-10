class AddCohorts < ActiveRecord::Migration[5.1]
  def change
    create_table :cohorts do |t|
      t.column :name, :string
      t.column :starts_at, :datetime
      t.column :ends_at, :datetime
      t.timestamps null: false
    end
  end
end
