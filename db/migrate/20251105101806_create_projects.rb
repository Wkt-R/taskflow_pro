class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :projects, [ :user_id, :status ]
    add_index :projects, :status
  end
end
