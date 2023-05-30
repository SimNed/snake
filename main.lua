local constants = require 'constants'
local initializers = require 'initializers'

local _game = {
    state = {
        start_menu = false,
        game_running = true,
        game_over = false,
    }
}

local _grid = initializers.init_grid(constants.GRID_SIZE, constants.FREE_ID)
local _snake = initializers.init_snake(constants.SNAKE_DEFAULT_SIZE, constants.SNAKE_DEFAULT_POSITION, constants.SNAKE_DEFAULT_DIRECTION)

local _direction = constants.SNAKE_DEFAULT_DIRECTION
local _tempDirection = _direction
local _refreshDelay = constants.DEFAULT_REFRESH_DELAY
local _timer = 0

function move_snake(position)
    local tempPosition = {}
    local targetPosition = position

    for i = 1, #_snake do
        tempPosition = _snake[i]    
        _snake[i] = targetPosition
        targetPosition = tempPosition
    end
end

function check_next_position_state(position)
    if position.x < 0 or position.x >= #_grid or position.y < 0 or position.y >= #_grid then
        _game.state.game_running = false
        _game.state.game_over = true
    elseif _grid[position.x][position.y] == 0 then
        move_snake(position)
    end
end

function check_direction_update()
    if (_direction.x ~= 0 and _tempDirection.x ~= _direction.x * -1) or (_direction.y ~= 0 and _tempDirection.y ~= _direction.y * -1)  then
        _direction = _tempDirection
    end
end

-- CORE --

function love.load()

end

function love.update(dt)
    if _game.state.game_running then
        if love.keyboard.isDown("left") then
            _tempDirection = {x = -1, y = 0}
        elseif love.keyboard.isDown("right") then
            _tempDirection = {x = 1, y = 0}
        elseif love.keyboard.isDown("up") then
            _tempDirection = {x = 0, y = -1}
        elseif love.keyboard.isDown("down") then
            _tempDirection = {x = 0, y = 1}
        end

        _timer = _timer + dt

        if _timer > _refreshDelay then
            check_direction_update()
            check_next_position_state({ x = _snake[1].x + _direction.x, y = _snake[1].y + _direction.y })

            _timer = 0
        end
    end
end

function love.draw()
    if _game.state.game_running then
        for i = 1, #_snake do
            love.graphics.rectangle(
                'fill',
                _snake[i].x * constants.WINDOW_SCALE,
                _snake[i].y * constants.WINDOW_SCALE,
                constants.WINDOW_SCALE,
                constants.WINDOW_SCALE
            )
        end
    elseif _game.state.game_over then
        love.graphics.print("GAME OVER")
    end
end