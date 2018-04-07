music(0, 0)

-- Special Function That Runs Once at the Start of Our Game
function _init()
    cls()
    char = generate_char()
    config = generate_config()
    projectile = generate_projectile()
end

-- Special Function the runs 30 times per second automatically and draws our graphics
function _draw()
    cls()
    if config.mode == 0 then
        print("troll 2: the movie: the game", 10, 20, 11)
        spr(config.bag, 30, 30, 2, 2)
        spr(config.bag, 87, 30, 2, 2)
        spr(char.spr_current, 57, 30, 2, 2)
        print("(press a to start)", 30, 50, config.shawn)
        if config.bag == 8 then
            config.bag = 10
        elseif config.bag == 10 then
            config.bag = 12
        elseif config.bag == 12 then
            config.bag = 14
        elseif config.bag == 14 then
            config.bag = 8
        end
    elseif config.mode == 1 then
        print_stats()
        spr(char.spr_current,char.xpos,char.ypos,char.spr_ht,char.spr_wt,char.flipx)
        if (char.fire == true) then
            spr(projectile.spr_num, projectile.xpos, projectile.ypos, 1, 1)
        end
        if bad_guy.alive == true then
            spr(bad_guy.spr_num,bad_guy.xpos,bad_guy.ypos,char.spr_ht,char.spr_wt)
        end
    elseif config.mode == 2 then
        print("game over", 50, 30, config.shawn)
        print("you defeated", 45, 48, 12)
        print(config.cleared, 67, 55, config.shawn)
        print("enemies!", 55, 62, 8)
    elseif config.mode == 3 then
        print("you win the treasure!", 15, 20, config.shawn)
        spr(38, 45, 25, 2, 2)
        print("credits:", 38, 50, 14)
        print("music director", 24, 58, 15)
        print("shawn obrien", 28, 65, config.shawn)
        print("art director", 28, 77, 3)
        print("shawn obrien", 28, 83, config.shawn)
        print("lead developer", 24, 95, 4)
        print("mark baggett", 28, 102, config.shawn)
    end
    if config.shawn == 15 then
        config.shawn = 0
    end
    config.shawn += 1

end

-- Special Function that runs 30 times per seconds and updates game state and checks for user input
function _update()
    if config.mode == 0 then
        detect_c()
    elseif config.mode == 1 then
        main_update()
    else
        detect_c()
    end
end

-- Function to dectect input from user at start, game over, and win screens
function detect_c()
    if (btnp(4)) and config.mode == 0 then
        main_update()
        config.mode = 1
    elseif (btnp(5)) and config.mode >= 2 then
        config = generate_config()
        projectile = generate_projectile()
        char = generate_char()
        bad_guy.alive = false
    end
end

-- Detects user inputs during the main part of the game and changes values associated with our Goblin
function detect_inputs()
    if (btn(0)) then
        char.spr_current = char.spr_left
        char.flipx = true
        char:move(-1, 0)
        char.direction = 3
    elseif (btn(1)) then
        char.spr_current = char.spr_right
        char.flipx = false
        char:move(1, 0)
        char.direction = 4
    elseif (btn(2)) then
        char.spr_current = char.spr_up
        char.flipx = false
        char.direction = 2
        char:move(0, -1)
    elseif (btn(3)) then
        char.spr_current = char.spr_down
        char.flipx = false
        char.direction = 1
        char:move(0, 1)
    elseif (btn(4)) and (char.fire == false) then
        char.fire = true
        projectile.direction = char.direction
        projectile.xpos = char.xpos
        projectile.ypos = char.ypos
        sfx(2)
    elseif (btn(5)) then
        char:teleport()
    end
end

-- Manipulates our fireball when the Goblin's fire property is set to true
function detect_projectile()
    if (char.fire == true) then
        if (projectile.direction == 1) then
            projectile:move(0, projectile.speed * 1)
        elseif (projectile.direction == 2) then
            projectile:move(0, projectile.speed * -1)
        elseif (projectile.direction == 3) then
            projectile:move(projectile.speed * -1, 0)
        else
            projectile:move(projectile.speed * 1,0)
        end
        collision_detection()
    end
end

-- Function to tell our bad_guy what to do during his turn
function enemy_turn()
    local new_x = 0
    local new_y = 0
    local speed = bad_guy.speed
    if (char.xpos < bad_guy.xpos) then
        new_x = -1 * speed
    elseif (char.xpos > bad_guy.xpos) then
        new_x = 1 * speed
    end
    if (char.ypos < bad_guy.ypos) then
        new_y = -1 * speed
    elseif (char.ypos > bad_guy.ypos) then
        new_y = 1 * speed
    end
    bad_guy:move(new_x, new_y)
    if bad_guy.last_hit > 0 then
        bad_guy.last_hit -= 1
    elseif (char.xpos >= bad_guy.xpos - 8 and char.xpos <=  bad_guy.xpos + 8) and (char.ypos >= bad_guy.ypos - 8 and char.ypos <= bad_guy.ypos + 8) and (bad_guy.alive == true) then
        char.health -= bad_guy.damage
        bad_guy.last_hit = config.grace
        sfx(1)
    end
end

-- Function to give instructions when our projectile collides with an enemy
function collision_detection()
    if (projectile.xpos >= bad_guy.xpos - 8 and projectile.xpos <=  bad_guy.xpos + 8) and (projectile.ypos >= bad_guy.ypos - 8 and projectile.ypos <= bad_guy.ypos + 8) then
        char.fire = false
        bad_guy.health -= projectile.damage
        if bad_guy.health <= 0 then
            bad_guy.alive = false
            config.cleared += 1
        end
    end
    if config.cleared >= config.win then
        config.mode = 3
    elseif config.cleared >= 40 then
        projectile.spr_num = 57
    elseif config.cleared >= 30 then
        projectile.spr_num = 56
    elseif config.cleared >= 20 then
        projectile.spr_num = 41
    end
end

-- Function that prints our stats to the screen during the main game
function print_stats()
    local hearts = ""
    local bhearts = ""
    print(char.name,1,1,11)
    for i = 1, char.health do
        hearts = hearts .. "♥"
    end
    print(hearts,1,10,config.shawn)
    print("defeated", 42, 1, 6)
    print(config.cleared, 59, 10, 8)
    print(bad_guy.name,85, 1, 9)
    for i = 1, bad_guy.health do
        bhearts = bhearts .. "♥"
    end
    print(bhearts,85,10,8)
end

-- Function that instantiates a new enemy
function generate_enemy()
    local x = flr(rnd(4)) + 1
    local y = flr(rnd(6)) + 1
    local enemy = {
        xpos = 1,
        ypos = 10,
        spr_num = 36,
        spr_ht = 2,
        spr_wt = 2,
        health = 3,
        speed = .5,
        alive = true,
        name = "farmer",
        damage = 1,
        last_hit = 0,

        move = function(self, x, y)
            self.xpos += x
            self.ypos += y
        end
    }
    if x == 1 then
        enemy.spr_num = 34
        enemy.name = "knight"
        enemy.damage = 2
        enemy.health = 4
        enemy.speed = .7
    elseif x == 2 then
        enemy.spr_num = 44
        enemy.name = "assasin"
        enemy.speed = 1.3
        enemy.health = 1
    elseif x == 3 then
        enemy.spr_num = 42
        enemy.name = "shroom"
        enemy.health = 5
    else
        enemy.spr_num = 36
        enemy.name = "farmer"
    end
    if y == 1 then
        enemy.xpos = 120
        enemy.ypos = 120
    elseif y == 2 then
        enemy.xpos = 120
    elseif y == 3 then
        enemy.ypos = 120
    elseif y == 4 then
        enemy.xpos = 60
    elseif y == 5 then
        enemy.xpos = 70
        enemy.ypos = 120
    end
    return enemy
end

-- Function to control the main part of our game including: what is game over, when to generate an enemy, etc.
function main_update()
    if char.health <= 0 then
        config.mode = 2
    end
    if config.enemy == 0 then
        bad_guy = generate_enemy()
        config.enemy = 1
    end
    detect_inputs()
    detect_projectile()
    enemy_turn()
    if bad_guy.alive == false then
        config.enemy = 0
    end
end

-- Function to instantiate the configuration information for our game
function generate_config()
    local config = {
        mode = 0,
        level = 1,
        top_screen = 15,
        bottom_screen = 110,
        far_left = 2,
        far_right = 111,
        grace = 10,
        shawn = 0,
        enemy = 0,
        cleared = 0,
        bag = 8,
        win = 50,
    }
    return config
end

-- Function to generate the player character
function generate_char()
    local char = {
        xpos = 50,
        ypos = 50,
        spr_current = 4,
        spr_up = 32,
        spr_down = 4,
        spr_left = 6,
        spr_right = 6,
        spr_ht = 2,
        spr_wt = 2,
        weapon = 1,
        flipx = false,
        fire = false,
        direction = 1,
        health = 4,
        name = "jenkem",

        move = function(self, x, y)
            self.xpos += x
            self.ypos += y
            if self.xpos < config.far_left then
                self.xpos = config.far_left
            elseif self.xpos > config.far_right then
                self.xpos = config.far_right
            end
            if self.ypos < config.top_screen then
                self.ypos = config.top_screen
            elseif self.ypos > config.bottom_screen then
                self.ypos = config.bottom_screen
            end
        end;

        teleport = function(self)
            self.xpos = flr(rnd(110)) + 10
            self.ypos = flr(rnd(110)) + 5
            if self.ypos < config.top_screen then
                self.ypos = config.top_screen
            elseif self.ypos > config.bottom_screen then
                self.ypos = config.bottom_screen
            end
        end

    }
    return char
end


-- Function to generate our fireballs
function generate_projectile()
    local projectile = {
        xpos = char.xpos,
        ypos = char.ypos,
        spr_num = 40,
        spr_ht = 1,
        spr_wt = 1,
        flipx = false,
        speed = 2,
        damage = 1,

        move = function(self, x, y)
            self.xpos += x
            self.ypos += y
            if (self.xpos <= 0) or (self.xpos >= 122) or (self.ypos <= 0) or (self.ypos >= 122) then
                char.fire = false
            end
        end
    }
    return projectile
end