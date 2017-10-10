class CreateEmpires < ActiveRecord::Migration
  def change
    create_table :empires do |t|
      t.string :name
      t.integer :ship_id
      t.integer :agent_id
    end
  end
end
