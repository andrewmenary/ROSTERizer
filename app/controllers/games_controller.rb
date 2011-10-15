class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    @home_team = Team.find(@game.home_team_id)
    @away_team = Team.find(@game.away_team_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new
    @home_team = Team.new
    @away_team = Team.new
    @players = Player.order :firstname, :lastname
    
    names = ["Predators", "Lions", "Railers", 
             "Tornadoes", "Steamrollers", "Beachcombers",
             "Gladiators", "Gorillas", "Jugernauts"].sort_by { rand }
    @home_team.name = names.pop
    @away_team.name = names.pop

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    @home_team = Team.find(@game.home_team_id)
    @away_team = Team.find(@game.away_team_id)
    @players = Player.order :firstname, :lastname
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])
	
    #First update the players table to indicate who is playing this game
    set_player_availability(params)
    
    #Create a team to hold the home team players
    home_team = Team.new
    home_team.name = params[:home_team_name]
    home_team.save
    @game.home_team_id = home_team.id
    
    #Create a team to hold the away team players
    away_team = Team.new
    away_team.name = params[:away_team_name]
    away_team.save
    @game.away_team_id = away_team.id
    
    #Create home and away teams from available players
    build_teams(home_team, away_team)
    
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    #First update the players table to indicate who is playing this game
    set_player_availability(params)
    
    #Find teams and update their names
    home_team = Team.find(@game.home_team_id)
    home_team.name = params[:home_team_name]
    away_team = Team.find(@game.away_team_id)
    away_team.name = params[:away_team_name]
    
    #Create home and away teams from available players
    build_teams(home_team, away_team)
    
    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :ok }
    end
  end
  
  private
  def set_player_availability(params)
    for player in Player.all
	  if params[:player]["#{player.id}"] == "available"
	    player.isavailable = true
	  else
	    player.isavailable = false
	  end
	  player.save
    end
  end
  
  def get_all_available_players
    @players = Player.where('isavailable is true').order('points')
  end
  
  def build_teams(home_team, away_team)
    #Find the players who are playing ordered by their performance points
    players = get_all_available_players
    
    team1 = {}
    team2 = {}
    
    #Assign the players to teams
    players.each_with_index do |player, i|
      if (i % 2) == 0
        team1["#{player.id}"] = "1"
      else
        team2["#{player.id}"] = "2"
      end
    end
    
    #Randomly choose which teams are going to be home and away
    teams = [team1, team2].sort_by { rand }
    
    #Assign and save players to the home team side
    home_team.player_list = teams[0]
    home_team.save
    
    #Assign and save players to the away team side
    away_team.player_list = teams[1]
    away_team.save
  end
end
