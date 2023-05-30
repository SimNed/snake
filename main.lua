local constants = require 'constants'
local initializers = require 'initializers'

local game = {
    state = {
        start_menu = true,
        game_running = fale,
        game_over
    }
}

local grid = initializers.init_grid(constants.GRID_SIZE, constants.FREE_ID)
local snake = initializers.init_snake(constants.SNAKE_DEFAULT_SIZE, constants.SNAKE_DEFAULT_POSITION, constants.SNAKE_DEFAULT_DIRECTION)

local direction = constants.SNAKE_DEFAULT_DIRECTION
local tempDirection = direction
local refreshDelay = constants.DEFAULT_REFRESH_DELAY
local timer = 0

function move_snake(cellPositions, direction)
    local tempPosition = {}
    local targetPosition = {
        x = cellPositions[1].x + direction.x, 
        y = cellPositions[1].y + direction.y
    }

    for i = 1, #cellPositions do
        tempPosition = cellPositions[i]    
        cellPositions[i] = targetPosition
        targetPosition = tempPosition
    end
end

function love.load()

end

function love.update(dt)
    if love.keyboard.isDown("left") then
        tempDirection = {x = -1, y = 0}
      elseif love.keyboard.isDown("right") then
        tempDirection = {x = 1, y = 0}
      elseif love.keyboard.isDown("up") then
        tempDirection = {x = 0, y = -1}
      elseif love.keyboard.isDown("down") then
        tempDirection = {x = 0, y = 1}
    end

    timer = timer + dt

    if timer > refreshDelay then
        if (direction.x ~= 0 and tempDirection.x ~= direction.x * -1) or (direction.y ~= 0 and tempDirection.y ~= direction.y * -1)  then
            direction = tempDirection
        end
        move_snake(snake, direction)
        timer = 0
    end
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