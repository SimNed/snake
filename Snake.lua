local game_constants = require('constants')

local DEFAULT_SNAKE_SIZE = 4
local DEFAULT_SNAKE_POSITION = {
    x = (game_constants.GRID_SIZE - 1) / 2, 
    y = (game_constants.GRID_SIZE - 1) / 2,
}
local DEFAULT_SNAKE_DIRECTION = {x = 0, y = -1}

local SNAKE_COLOR = {1,1,1,1}

local D

function initCellPositions(size, position, direction)
    local positions = {}
    local tempPosition = position

    for i = 1, size do
        table.insert(positions, tempPosition)
        tempPosition = {x = tempPosition.x - direction.x, y = tempPosition.y - direction.y}
    end

    return positions
end

local Snake = {
        cellPositions = initCellPositions(DEFAULT_SNAKE_SIZE, DEFAULT_SNAKE_POSITION, DEFAULT_SNAKE_DIRECTION),

        move = function (snake, direction)
            local tempPosition = {}
            local targetPosition = {
                x = snake[1].x + direction.x, 
                y = snake[1].y + direction.y
            }

            for i = 1, #snake do
                tempPosition = snake[i]    
                snake[i] = targetPosition
                targetPosition = tempPosition
            end
        end,

        draw = function (self)
            love.graphics.setColor(SNAKE_COLOR)
            for i = 1, #cellPositions do
                love.graphics.rectangle(
                    'fill',
                    cellPositions[i].x * game_constants.WINDOW_SCALE,
                    cellPositions[i].y * game_constants.WINDOW_SCALE,
                    game_constants.WINDOW_SCALE,
                    game_constants.WINDOW_SCALE
                )
                love.graphics.print(cellPositions[i].y)
            end
        end
    }

return Snake