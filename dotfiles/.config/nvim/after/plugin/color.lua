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
string.format("'yellow': ['%s', '0'],",   HSV2RGB(310, 0.45, 0.9)) .. -- strings
string.format("'green':  ['%s', '0'],",   HSV2RGB(190, 0.45, 0.9)) .. -- function names
string.format("'blue':   ['%s', '0'],",   HSV2RGB(190, 0.45, 0.9)) .. -- packages
string.format("'orange': ['%s', '0'],",   HSV2RGB(0  , 0.00, 1.0)) .. -- struct/class vars
string.format("'purple': ['%s', '0'],",   HSV2RGB(260, 0.45, 0.9)) .. -- numbers
string.format("'red':    ['%s', '250']}", HSV2RGB(220, 0.45, 0.9)))   -- keywords


-- https://github.com/sainnhe/sonokai/blob/master/doc/sonokai.txt
vim.g.sonokai_transparent_background = true
vim.g.sonokai_disable_italic_comment = true
vim.cmd("colorscheme sonokai")
