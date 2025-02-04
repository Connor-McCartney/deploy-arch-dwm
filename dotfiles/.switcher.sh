# turn off Windows key because that's what triggers this
xte 'keyup Super_L'

# save
xte 'key Escape' 'str :w' 'key Return'

# switch
xte 'keydown Super_L' 'keydown Tab' 'keyup Super_L' 'keyup Tab'
sleep 0.1

# clear
xte 'keydown Control_L' 'keydown l' 'keyup Control_L' 'keyup l'

# run
xte 'key Up' 'key Return'
