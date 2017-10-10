class Ships < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :type_class
      t.string :sub_class
      t.decimal :top_speed
      t.integer :crew
      t.string :affiliation
      t.integer :agent_id
      t.string :note
    end
  end
end
