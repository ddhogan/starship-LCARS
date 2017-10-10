class Agents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :username
      t.string :password_digest
    end
  end
end
