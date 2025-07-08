local function Round(x)
    return math.floor(x+0.5)
end

local function HSV2RGB (h, s, v)
    local k1 = v*(1-s)
    local k2 = v-k1
    local r = math.min(math.max(3*math.abs(((h    )/180)%2-1)-1,0),1)
    local g = math.min(math.max(3*math.abs(((h-120)/180)%2-1)-1,0),1)
    local b = math.min(math.max(3*math.abs(((h+120)/180)%2-1)-1,0),1)
    r = Round((k1+k2*r) * 255)
    g = Round((k1+k2*g) * 255)
    b = Round((k1+k2*b) * 255)
    return string.format("#%02x%02x%02x", r, g, b)
end


vim.cmd("let g:sonokai_colors_override = {" ..
--string.format("'grey':   ['%s', '0'],",   HSV2RGB(270, 0.40, 1.0)) .. -- comments
string.format("'purple': ['%s', '0'],",   HSV2RGB( 50, 0.50, 1.0)) .. -- numbers
string.format("'yellow': ['%s', '0'],",   HSV2RGB(100, 0.50, 1.0)) .. -- strings
string.format("'orange': ['%s', '0'],",   HSV2RGB(150, 0.50, 1.0)) .. -- struct/class vars
string.format("'blue':   ['%s', '0'],",   HSV2RGB(200, 0.50, 1.0)) .. -- packages
string.format("'green':  ['%s', '0'],",   HSV2RGB(250, 0.50, 1.0)) .. -- function names
string.format("'fg':     ['%s', '0'],",   HSV2RGB(300, 0.50, 1.0)) .. -- variables
string.format("'red':    ['%s', '250']}", HSV2RGB(350, 0.50, 1.0)))   -- keywords

--vim.cmd("let g:sonokai_colors_override = {" ..
----string.format("'grey':   ['%s', '0'],",   HSV2RGB(270, 0.40, 1.0)) .. -- comments
--string.format("'purple': ['%s', '0'],",   HSV2RGB(314, 0.40, 1.0)) .. -- numbers
--string.format("'yellow': ['%s', '0'],",   HSV2RGB(194, 0.30, 1.0)) .. -- strings
--string.format("'orange': ['%s', '0'],",   HSV2RGB(218, 0.40, 1.0)) .. -- struct/class vars
--string.format("'blue':   ['%s', '0'],",   HSV2RGB(242, 0.40, 1.0)) .. -- packages
--string.format("'green':  ['%s', '0'],",   HSV2RGB(314, 0.50, 1.0)) .. -- function names
--string.format("'fg':     ['%s', '0'],",   HSV2RGB(290, 0.35, 1.0)) .. -- variables
--string.format("'red':    ['%s', '250']}", HSV2RGB(266, 0.40, 1.0)))   -- keywords


-- https://github.com/sainnhe/sonokai/blob/master/doc/sonokai.txt
vim.g.sonokai_transparent_background = true
vim.g.sonokai_disable_italic_comment = true
vim.cmd("colorscheme sonokai")
