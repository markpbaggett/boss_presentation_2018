char = {
    spr_num = 4,
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
    spr(char.spr_num, char.x_pos, char.y_pos, 2, 2)
end
