-- https://github.com/sphamba/smear-cursor.nvim

local opts = {
    stiffness = 1,
    trailing_stiffness = 0.4,
    distance_stop_animating = 1,0
}

require('smear_cursor').setup(opts)
