class AddRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.column :mentor_id, :bigint
      t.column :mentee_id, :bigint
      t.references :cohort
      t.timestamps null: false
    end
  end
end
