class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :status, default: 0
      t.integer :priority, default: 0
      t.date :duedate
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end

    add_index :tasks, [ :project_id, :status ]
    add_index :tasks, [ :project_id, :priority ]
    add_index :tasks, :duedate
  end
end
