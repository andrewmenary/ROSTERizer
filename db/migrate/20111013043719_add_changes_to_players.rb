class AddChangesToPlayers < ActiveRecord::Migration
  def change
    change_table :players do |t|
	  t.rename :loses, :losses
	  t.integer :points
	end
  end
end
