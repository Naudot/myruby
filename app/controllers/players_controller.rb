class PlayersController < ApplicationController

  def index
	
	# View variables
	@players = Player.all # Get all players from Database
	@championSuitorsHash = Hash.new # Key is ELO, Value is an array of Players
	@champions = [] # Final list of champions

	if @players == nil
		return
	end

	# First step : We put players in a hash using their ELO and comparing their age.

	# For each player, we check the players with the same elo
	@players.each do |player|
		# Check if the database player is properly set
		if player.age == nil || player.elo == nil
			next
		end

		championSuitors = @championSuitorsHash[player.elo]

		if championSuitors == nil # If there is no one at this ELO yet
			@championSuitorsHash[player.elo] = [player] # We create the array with the player
		else # Else if there are already one or more players with this ELO 
			championSuitor = championSuitors[0] # Because every champions at this ELO is same ELO and age, we can check only the first of the champion suitors
			
			if championSuitor.age < player.age # Check if the player is younger than the champion suitor(s) and if this is the case, the player replaces the champion suitor(s)
				@championSuitorsHash[player.elo].clear()
				@championSuitorsHash[player.elo] = [player]
			elsif championSuitor.age == player.age # If same age, we add the player as a potential champion suitor
				@championSuitorsHash[player.elo].push(player)
			end
		end
	end
	
	# We sort the hash by ELO from highest to lowest
	@championSuitorsHash = @championSuitorsHash.sort.reverse.to_h

	# Second step, we check if they are champions by going through every encounterd ELO

	currentYoungest = Date.parse('01-01-0001')
	# We save the age of the maximum ELO champion then we compare it when going down in ELO
	@championSuitorsHash.keys.each do |championElo|
		# Because we are going down on ELOs, we only need to check if the best player at the current ELO is younger than the previous champion
		if @championSuitorsHash[championElo][0].age > currentYoungest # We check if his birth date is more recent than the previous champion birth date
			currentYoungest = @championSuitorsHash[championElo][0].age
			championsAtSameELO = []
			@championSuitorsHash[championElo].each do |champion|
				championsAtSameELO.push([champion.name, champion.age, champion.elo])
			end
			@champions.push(championsAtSameELO)
		end
	end

  end

  def show
	@player = Player.find(params[:id])
  end
end
