char = {
    spr_val = 4,
    x_pos = 60,
    y_pos = 60,
    spr_ht = 2,
    spr_wt = 2,
    health = 4,
    name = "grishnakh",
    spr_flipx = false,
}

function _init()
    cls()
end

function _draw()
    cls()
    spr(char.spr_val, char.x_pos, char.y_pos, char.spr_ht, char.spr_wt, char.spr_flipx)
end