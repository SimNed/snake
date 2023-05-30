local constants = require 'constants'
local initializers = require 'initializers'

local _game = {
    state = {
        start_menu = false,
        game_running = false,
        game_over = false,
    }
}

local _snake = initializers.init_snake(constants.SNAKE_DEFAULT_SIZE, constants.SNAKE_DEFAULT_POSITION, constants.SNAKE_DEFAULT_DIRECTION)
local _grid = initializers.init_grid(constants.GRID_SIZE, _snake, constants.FREE_ID, constants.SNAKE_ID)

local _direction = constants.SNAKE_DEFAULT_DIRECTION
local _tempDirection = _direction

local _refreshDelay = constants.DEFAULT_REFRESH_DELAY
local _timer = 0

function move_snake(position)
    local tempPosition = {}
    local targetPosition = position

    _grid[targetPosition.x][targetPosition.y] = constants.SNAKE_ID

    for i = 1, #_snake do
        tempPosition = _snake[i]    
        _snake[i] = targetPosition
        targetPosition = tempPosition
    end

    _grid[targetPosition.x][targetPosition.y] = constants.FREE_ID
end

function check_next_position_state(position)
    if position.x < 0 or position.x >= #_grid or position.y < 0 or position.y >= #_grid then
        _game.state.game_running = false
        _game.state.game_over = true

    elseif _grid[position.x][position.y] == constants.FREE_ID then
        move_snake(position)
    elseif _grid[position.x][position.y] == constants.SNAKE_ID then
        _game.state.game_running = false
        _game.state.game_over = true
    end
end

function check_direction_update()
    if (_direction.x ~= 0 and _tempDirection.x ~= _direction.x * -1) or (_direction.y ~= 0 and _tempDirection.y ~= _direction.y * -1)  then
        _direction = _tempDirection
    end
end

-- CORE --

function love.load()
    _game.state.start_menu = true
    _game.state.game_running = false
    _game.state.game_over = false
end

function love.update(dt)
    if _game.state.start_menu then
        if love.keyboard.isDown("space") then
            _game.state.start_menu = false
            _game.state.game_running = true
        end

    elseif _game.state.game_running then
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
    if _game.state.start_menu then
        love.graphics.print("PRESS SPACE KEY")

    elseif _game.state.game_running then
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