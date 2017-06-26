class CreateWikis < ActiveRecord::Migration
  def change
    create_table :wikis do |t|
      t.string :title
      t.text :body
      t.boolean :private
      t.string :manufacture
      t.integer :year
      t.integer :displacement
      t.integer :category
      t.integer :hp
      t.integer :torque
      t.integer :cylinders
      t.integer :final_drive
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
