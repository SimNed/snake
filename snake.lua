local snake = {
    size = 4,
    color = { 1,1,1,1 },
    cell_positions = {},
    direction = { x = 0, y = -1 },
    
    init_cell_positions = function(self, grid_size)
        positions = {}
        tempPosition = { x = (grid_size - 1) / 2, y = (grid_size - 1) / 2 }
    
        for i = 1, self.size do
            table.insert(positions, tempPosition)
            tempPosition = {x = tempPosition.x - self.direction.x, y = tempPosition.y - self.direction.y}
        end
    
        self.cell_positions = positions
    end,

    move_snake = function(self, grid, position)
        tempPosition = {}
        targetPosition = position
    
        grid.matrix[targetPosition.x][targetPosition.y] = grid.cell_id.snake
    
        for i = 1, #self.cell_positions do
            tempPosition = self.cell_positions[i]    
            self.cell_positions[i] = targetPosition
            targetPosition = tempPosition
        end
    
        grid.matrix[targetPosition.x][targetPosition.y] = grid.cell_id.free
    end,

    draw = function(self, window_scale)
        love.graphics.setColor(self.color)

        for i = 1, self.size do
            love.graphics.rectangle(
                'fill',
                self.cell_positions[i].x * window_scale,
                self.cell_positions[i].y * window_scale,
                window_scale,
                window_scale
            )
        end
    end
}

return snake