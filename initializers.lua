return {
    init_grid = function(size, freeId) 
        local matrix = {}
  
        for i = 0, size do
            matrix[i] = {}
    
            for j = 0, size do
                matrix[i][j] = freeId
            end
        end

        return matrix
    end,
  
    init_snake = function(size, position, direction)
        local positions = {}
        local tempPosition = position

        for i = 1, size do
            table.insert(positions, tempPosition)
            tempPosition = {x = tempPosition.x - direction.x, y = tempPosition.y - direction.y}
        end

        return positions
    end,
}
