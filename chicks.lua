local chicks = {
    color = {1,1,0,1},
    chicks_positions = {},

    add_chicks = function(self, grid, chicks_number)
        for i = 1, chicks_number do
            chick_position = self.generate_random_chick_position(grid)
            table.insert(self.chicks_positions, chick_position)
            grid.matrix[chick_position.x][chick_position.y] = grid.cell_id.chick
        end
    end,

    generate_random_chick_position = function(grid)
        math.randomseed( os.time() )
    
        random_position = { x = math.random(0, grid.size - 1), y = math.random(0, grid.size - 1) }
        
        while grid.matrix[random_position.x][random_position.y] ~= grid.cell_id.free do
            random_position =  { x = math.random(0, grid.size), y = math.random(0, grid.size) }
        end
    
        return random_position
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