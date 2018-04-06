char = {
    spr_num = 4,
    x_pos = 60,
    y_pos = 60,
    spr_ht = 2,
    spr_wt = 2,
    health = 4,
    name = "grishnakh",
    flipx = false,
    teleport = function(self)
        self.x_pos = flr(rnd(110)) + 10
        self.y_pos = flr(rnd(110)) + 5
    end;
}

function _init()
    cls()
end

function _draw()
    cls()
    spr(char.spr_num, char.x_pos, char.y_pos, char.spr_ht, char.spr_wt, char.flipx)
end

function _update()
    if (btn(0)) then
        char.spr_num = 6
        char.flipx = true
        char.x_pos -=  1
    elseif (btn(1)) then
        char.spr_num = 6
        char.flipx = false
        char.x_pos += 1
    elseif (btn(2)) then
        char.spr_num = 32
        char.flipx = false
        char.y_pos -= 1
    elseif (btn(3)) then
        char.spr_num = 4
        char.flipx = false
        char.y_pos += 1
    elseif (btn(4)) then
        char:teleport()
    end
end