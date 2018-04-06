char = {
    spr_val = 4,
    x_pos = 60,
    y_pos = 60,
    spr_ht = 2,
    spr_wt = 2,
    health = 4,
}

function _init()
    cls()
end

function _draw()
    cls()
    spr(char.spr_val, char.x_pos, char.y_pos, 2, 2)
end
