local grid = {
    size = 35,
    matrix = {},
    cell_id = {
        free = 0,
        chick = 1,
        obstacle = 2,
        snake = 3,
    },
    
    init_matrix = function(self, snake) 
        local matrix = {}
  
        for i = 0, self.size do
            matrix[i] = {}
    
            for j = 0, self.size do
                matrix[i][j] = self.cell_id.free
            end
        end
        
        for i = 1, snake.size do
            matrix[snake.cell_positions[i].x][snake.cell_positions[i].y] = self.cell_id.snake
        end

        self.matrix = matrix
    end,
}

return grid