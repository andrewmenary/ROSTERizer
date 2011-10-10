class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :firstname
      t.string :lastname
      t.string :nickname
      t.integer :wins
      t.integer :ties
      t.integer :loses
      t.integer :goals
      t.integer :assists
      t.boolean :isactive
      t.boolean :isavailable

      t.timestamps
    end
  end
end
