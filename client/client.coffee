
@cityNames = [
	"Aarau"
	"Andermatt"
	"Basel"
	"Bellinzona"
	"Bern"
	"Biel"
	"Brig"
	"Chiasso"
	"Chur"
	"Davos"
	"Fribourg"
	"Genf"
	"Glarus"
	"Interlaken"
	"Kreuzlingen"
	"Lausanne"
	"Locarno"
	"Lugano"
	"Luzern"
	"Martigny"
	"Montreux"
	"Neuchatel"
	"Olten"
	"St. Gallen"
	"St. Moritz"
	"Schaffhausen"
	"Schwyz"
	"Sion"
	"Solothurn"
	"Thun"
	"Vaduz"
	"Winterthur"
	"Zermatt"
	"Zürich"
	"Zug"
]
allCities = [0..cityNames.length]

@distances = [
	[135]
	[65,168]
	[209,86,240]
	[84,146,96,219]
	[72,188,85,255,40]
	[215,80,247,128,170,204]
	[260,137,291,55,270,307,187]
	[164,94,199,115,241,274,172,170]
	[194,154,230,134,292,330,227,194,58]
	[113,168,125,251,33,70,181,290,263,320]
	[234,293,246,343,154,158,215,399,387,444,137]
	[116,100,152,185,225,188,178,238,72,100,240,382]
	[137,97,147,178,55,92,113,216,192,247,73,190,168]
	[109,171,150,242,192,188,250,296,128,157,222,345,92,195]
	[185,232,197,279,105,110,152,338,325,380,74,64,332,150,288]
	[226,105,158,18,238,275,107,66,126,160,256,322,195,184,278,260]
	[235,112,266,29,245,281,146,27,142,166,262,360,200,190,284,299,40]
	[63,73,95,145,122,105,138,196,166,170,139,255,105,66,139,200,164,170]
	[212,163,112,210,131,168,85,268,256,312,102,124,311,144,314,73,190,230,235]
	[169,212,181,248,90,128,122,306,306,361,60,93,292,133,272,31,229,268,272,42]
	[107,177,119,284,49,34,222,322,271,326,50,125,272,105,232,76,290,295,140,142,100]
	[13,125,53,199,67,62,190,249,184,212,99,220,136,120,135,172,217,222,54,197,155,96]
	[124,199,165,233,206,200,275,273,104,133,236,358,80,208,40,310,240,246,132,335,292,234,148]
	[238,162,284,151,309,343,240,135,75,68,330,455,148,260,205,395,165,126,274,324,374,340,260,176]
	[91,154,132,265,173,168,231,316,149,178,204,326,102,176,45,277,285,290,111,303,260,202,116,80,260]
	[75,56,118,126,180,142,231,178,150,141,199,342,66,124,133,238,146,152,37,218,260,176,90,95,190,100]
	[238,133,250,180,159,197,55,238,227,282,130,154,233,167,343,101,160,166,105,32,70,170,260,330,295,288,190]
	[52,182,65,269,40,24,204,308,211,240,70,192,164,198,155,134,275,280,81,170,128,58,38,177,290,125,128,197]
	[106,125,120,205,30,65,142,244,219,275,48,182,198,30,210,123,212,219,92,136,108,80,94,231,288,200,153,164,65]
	[153,133,189,153,280,224,212,208,40,70,302,426,60,230,92,366,176,182,132,295,345,310,174,66,118,145,104,266,200,258]
	[66,126,105,238,144,141,202,288,121,150,175,298,74,148,43,250,257,264,84,275,233,174,88,56,235,28,73,260,116,170,111]
	[260,124,290,170,212,249,445,230,217,273,208,232,222,157,295,180,150,157,195,110,148,248,250,321,285,277,180,80,275,186,256,250]
	[45,111,83,231,123,117,202,287,119,148,153,277,72,123,72,230,255,260,66,255,212,154,66,85,196,53,60,244,95,150,110,25,234]
	[53,79,120,150,153,130,168,226,116,145,170,285,69,96,112,232,170,175,30,265,304,170,84,97,193,92,27,212,111,126,105,65,202,41]
]

K_B = 1
T_initial = 3000
T_c = 0.3
@coolDown = (T) -> T * T_c

@metropolis = (e_new, e_old, T) ->
	if e_new < e_old then 1 else Math.exp(-(e_new-e_old)/(K_B*T))
@getDistance = (city1Index, city2Index) ->
	if distances[city1Index-1]?[city2Index]?
		return distances[city1Index-1][city2Index]
	else
		distances[city2Index-1]?[city1Index]

@getLengthOfTour = (tour) ->
	lastCity = null
	total = 0
	for city in tour
		if lastCity?
			distance = getDistance city, lastCity
			if distance?
				total += distance
		lastCity = city
	return total

@getNearestCity = (city, cities) ->
	_.min cities, (otherCity) ->
		getDistance city, otherCity

createInitialTour = ->
	initialCity = 0
	initialTour = [initialCity]
	remainingCities = _.clone allCities
	for i in [1..allCities.length-2]
		lastCity = initialTour[i-1]
		remainingCities = _(remainingCities).without lastCity
		initialTour.push getNearestCity lastCity, remainingCities
	initialTour.push initialCity
	return initialTour

@twoOptNeighbor = (tour) ->
	newTour = _.clone tour
	loop
		splitPoint1 = _.random 0, tour.length-2
		splitPoint2 = _.random 0, tour.length-2

		break if Math.abs(splitPoint2-splitPoint1) > 1
	if splitPoint2 < splitPoint1
		[splitPoint1, splitPoint2] = [splitPoint2, splitPoint1]

	
	part1 = tour[..splitPoint1]

	part2 = tour[splitPoint1+1..splitPoint2].reverse()

	part3 = tour[splitPoint2+1..]

	part1.concat(part2).concat(part3)

	


best = null
bestTour = null
START_WITH_BEST = yes
INNER_LOOPS = 200
OUTER_LOOPS = 200
doExperiment = ->
	
	if best? and START_WITH_BEST
		tour = bestTour
	else
		tour = createInitialTour()
		console.log "initial", getLengthOfTour(tour), (cityNames[city] for city in tour) unless best?
	
	T = T_initial
	for i in [1..OUTER_LOOPS]
		for j in [1..INNER_LOOPS]

			tour_new = twoOptNeighbor tour

			s_old = getLengthOfTour tour
			s_new = getLengthOfTour tour_new

			p = metropolis s_new, s_old, T
		
			tour = if p is 1 or Math.random() < p then tour_new else tour

		#console.log "outer", i, T, s_new, s_old
		T = coolDown T

	newLength = getLengthOfTour(tour)
	if not best? or newLength < best
		best = newLength
		bestTour = tour
	#console.log "end", newLength, (cityNames[city] for city in tour)
	console.log "best", best, (cityNames[city] for city in bestTour)


doExperiment() for i in [1..100]







