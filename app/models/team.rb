class Team < ActiveRecord::Base
  has_and_belongs_to_many :players
  
  attr_accessor :player_list
  after_save :update_players
  
  private
  
  def update_players
    players.delete_all
	selected_players = player_list.nil? ? [] : player_list.keys.collect{|id| Player.find_by_id(id)}
	selected_players.each {|player| self.players << player}
  end
end
