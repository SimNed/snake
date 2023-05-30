local constants = require 'constants'
local initializers = require 'initializers'

local grid = initializers.init_grid(constants.GRID_SIZE, constants.FREE_ID)
local snake = initializers.init_snake(constants.SNAKE_DEFAULT_SIZE, constants.SNAKE_DEFAULT_POSITION, constants.SNAKE_DEFAULT_DIRECTION)

local game = {
    state = {
        start_menu = true,
        game_running = fale,
        game_over
    }
}

function move_snake(snake, direction)
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
end

function love.load()

end

function love.update(dt)
    move_snake(snake, {x = 0, y = -1})
end

function love.draw()
    for i = 1, #snake do
        love.graphics.rectangle(
            'fill',
            snake[i].x * constants.WINDOW_SCALE,
            snake[i].y * constants.WINDOW_SCALE,
            constants.WINDOW_SCALE,
            constants.WINDOW_SCALE
        )
    end
end