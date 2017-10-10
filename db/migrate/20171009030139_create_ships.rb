class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :name
      t.integer :agent_id
      t.integer :empire_id
      t.string :type_class
      t.decimal :speed
      t.integer :crew
    end
  end
end
