class Player < ActiveRecord::Base
  validates :firstname, :lastname, :presence => true
  
  before_create :set_defaults
  
  def fullname
    if nickname.nil? or nickname.blank?
	  firstname + " " + lastname
	else
	  firstname + " \"" + nickname + "\" " + lastname
	end
  end
  
  protected
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
