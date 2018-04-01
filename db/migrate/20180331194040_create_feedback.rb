class CreateFeedback < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.column :text, :text
      t.column :user_id, :bigint
      t.column :relationship_id, :bigint

      t.timestamps null: false
    end

    add_index :feedbacks, :user_id
    add_index :feedbacks, :relationship_id
  end
end
