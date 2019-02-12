#simulation of the monty hall problem

sim_len = 10000

doors = LETTERS[1:3]

prize_door = sample(doors, sim_len, TRUE)

initial_selection = 'A'

revealed_door = unname(sapply(prize_door, function(x){
    sample(setdiff(doors[2:3], x), 1)
    }))

alternative_door = unname(sapply(revealed_door, function(x){
    setdiff(doors[2:3], x)
    }))

#probability of choosing prize door when selection does not change
sum(prize_door == 'A') / sim_len

#prob when selection does change
sum(prize_door == alternative_door) / sim_len


#intuition aid:
#your initial selection has a 1/3 probability of containing the prize
#the remaining two doors have a 2/3 probability of containing the prize
#when monty opens one of those two doors, he's effectively concentrating
    #that 2/3 probability in the alternative door.
#take it to an extreme: thre are 100 doors. your initial selection has a 1/100
    #prob of winning. then monty reveals 98 incorrect doors and gives you the
    #option of switching to the conspicuous final door. Clearly this door has
    #more potential than your first guess.
