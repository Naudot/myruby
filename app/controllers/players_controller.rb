class PlayersController < ApplicationController

  def index
	@players = Player.all

	# Key is ELO, Value is an array of Players
	@championSuitorsHash = Hash.new

	# First step, we sort players in a hash using their ELO and age.

	# For each player, we check the players with the same elo
	@players.each do |player|
		championSuitors = @championSuitorsHash[player.elo]

		if championSuitors == nil # If there is no one at this ELO yet
			@championSuitorsHash[player.elo] = [player] # We create the array with the player
		else
			championSuitor = championSuitors[0] # Because every champions at this ELO is same ELO and age, we can only check the first of the champion suitors
			if championSuitor.age < player.age # Check if the player is younger than the champion(s)
				@championSuitorsHash[player.elo].clear()
				@championSuitorsHash[player.elo] = [player]
			elsif championSuitor.age == player.age # If same age, we add the player as a potential champion
				@championSuitorsHash[player.elo].push(player)
			end
		end
	end
	
	currentYoungest = Date.parse('01-01-0001')

	@championSuitorsHash = @championSuitorsHash.sort.reverse.to_h
	@champions = []

	# Second step, we check if they are champions

	# We save the age of the maximum ELO champion then we compare it when going down in ELO
	@championSuitorsHash.keys.each do |championElo|
		# Because we are going down on ELOs, we only need to check if the best player at the current ELO is younger than the previous champion
		if @championSuitorsHash[championElo][0].age > currentYoungest
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

	# petite idée pour l'exo du chess, on créé un hashset des elos, et à chaque elo on link le joueur à cet élo qui a le plus bas âge
	# donc on a juste besoin de parcourir chaque joueur et leur élo une fois
	# ensuite on parcours tous les élos en partant de l'élo le plus élevé (la personne avec l'élo le plus élevé sera toujours championne)
	# en gardant l'âge le plus bas et on détermine les@championSuitorsHash
	# exemple : ELO 3000 John âge 25 -> Champion
	# ELO 2999 Jean âge 30 -> PAS Champion car âge mini 25
	# ELO 2998 Marie âge 25 -> Championne car âge mini 25, l'âge mini passe à 24
	# 
	# l'âge mini est de 25 quand on dépasse John et l'élo max est 3000 donc c'est un champion
	# mais l'âge mini au dessus de Marie est 30 ce qui est inférieur donc ce n'est pas une championne
	# je considère deux personnes nées le même jour et au même élo toutes les deux championnes

	# donc la structure de données finale est un tableau d'élo, chaque élo associé à une ou plusieurs personne et à une date de naissance
  end
end
