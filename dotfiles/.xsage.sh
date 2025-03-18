xte 'keyup Super_L' 'keyup x' 'keyup Return'

# open terminal
xte 'keydown Super_L' 'keydown Return' 'keyup Super_L' 'keyup Return'
sleep 0.4

# open neovim
xte 'str nvim x.sage'
xte 'keydown Return' 'keyup Return' 
xte 'str :w'
xte 'keydown Return' 'keyup Return' 

# open another terminal
xte 'keydown Super_L' 'keydown Return' 'keyup Super_L' 'keyup Return'
sleep 0.4

# run it
xte 'str sage x.sage'
xte 'keydown Return' 'keyup Return' 

# switch
xte 'keydown Super_L' 'keydown Tab' 'keyup Super_L' 'keyup Tab'
