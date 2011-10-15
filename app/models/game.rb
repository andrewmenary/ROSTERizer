class Game < ActiveRecord::Base
  has_one :team, :foreign_key => "home_team_id"
  has_one :team, :foreign_key => "away_team_id"
  
  def display_name
    "#{date}"
  end
end
