class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams
  
  validates :firstname, :lastname, :presence => true
  
  before_create :set_defaults
  before_save :calculate_points
  
  def fullname
    if nickname.nil? or nickname.blank?
	  firstname + " " + lastname
	else
	  firstname + " \"" + nickname + "\" " + lastname
	end
  end
  
  protected
  def calculate_points
    self.points = (wins * 2) + (ties) - (losses) + (goals * 2) + (assists)
  end
  
  def set_defaults
    self.wins = 0
	self.ties = 0
	self.loses = 0
	self.goals = 0
	self.assists = 0
	self.isactive = true
	self.isavailable = true
  end
end
