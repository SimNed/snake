local chicks = {
    color = {1,1,0,1},
    chicks_positions = {},

    add_chicks = function(self, grid, chicks_number)
        for i = 1, chicks_number do
            position = self.generate_random_chick_position(grid)
            table.insert(self.chicks_positions, position)
            grid.matrix[position.x][position.y] = grid.cell_id.chick
        end
    end,

    generate_random_chick_position = function(grid)
        math.randomseed( os.time() )
    
        random_position = { x = math.random(0, grid.size - 1), y = math.random(0, grid.size - 1) }
        
        while grid.matrix[random_position.x][random_position.y] ~= grid.cell_id.free do
            random_position =  { x = math.random(0, grid.size - 1), y = math.random(0, grid.size - 1) }
        end
    
        return random_position
    end,

    delete_chick = function(self, position)
        for key, value in pairs(self.chicks_positions) do
            if value.x == position.x and value.y == position.y then
                table.remove(self.chicks_positions, key)
            end
        end
    end,

    draw = function(self, window_scale)
        love.graphics.setColor(self.color)

        for i = 1, #self.chicks_positions do
            love.graphics.rectangle(
                'fill',
                self.chicks_positions[i].x * window_scale,
                self.chicks_positions[i].y * window_scale,
                window_scale,
                window_scale
            )
        end
    end
}

return chicks