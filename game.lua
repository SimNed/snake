local game = {
    state = {
        start_menu = false,
        game_running = false,
        game_over = false,
    },
    window_scale = 10,
    timer = 0,
    refresh_delay = .2,
    chicks_score = 0,
    temp_direction = {},

    check_next_position_state = function(self, position, grid, snake, chicks)
        if position.x < 0 or position.x >= grid.size or position.y < 0 or position.y >= grid.size then
            self.state.game_running = false
            self.state.game_over = true
    
        elseif grid.matrix[position.x][position.y] == grid.cell_id.free then
            snake:move_snake(grid, position)
    
        elseif grid.matrix[position.x][position.y] == grid.cell_id.snake then
            self.state.game_running = false
            self.state.game_over = true
    
        elseif grid.matrix[position.x][position.y] == grid.cell_id.chick then
            if self.refresh_delay > .045 then
                self:update_refresh_delay()
            end
            snake:move_snake(grid, position)
            snake:add_cell()
            chicks:add_chicks(grid, 1)
            chicks:delete_chick(position)
            self.chicks_score = self.chicks_score + 1 
        end
    end,

    check_direction_update = function(self, snake)
        if (snake.direction.x ~= 0 and self.temp_direction.x ~= snake.direction.x * -1) or (snake.direction.y ~= 0 and self.temp_direction.y ~= snake.direction.y * -1)  then
            snake.direction = self.temp_direction
        end
    end,

    update_refresh_delay = function(self)
        self.refresh_delay = self.refresh_delay * (0.9)
    end,

    draw_start_menu = function(self)
        love.graphics.setColor({1,1,1,1})
        love.graphics.print("PRESS SPACE KEY")
    end,
    
    draw_score = function(self)
        love.graphics.setColor({1,1,1,1})
        love.graphics.print(self.chicks_score)
    end,

    draw_game_over_menu = function(self)
        love.graphics.setColor({1,1,1,1})
        love.graphics.print("GAME OVER")
    end,
}

return game