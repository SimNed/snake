local _game = require 'game'

local _snake = require 'snake'
local _grid = require 'grid'
local _chicks = require 'chicks'

local _tempDirection = {}

--- FUNCTIONS ---

function check_next_position_state(position)
    if position.x < 0 or position.x >= _grid.size or position.y < 0 or position.y >= _grid.size then
        _game.state.game_running = false
        _game.state.game_over = true

    elseif _grid.matrix[position.x][position.y] == _grid.cell_id.free then
        _snake:move_snake(_grid, position)

    elseif _grid.matrix[position.x][position.y] == _grid.cell_id.snake then
        _game.state.game_running = false
        _game.state.game_over = true

    elseif _grid.matrix[position.x][position.y] == _grid.cell_id.chick then
        _snake:move_snake(_grid, position)
        _chicks:add_chicks(_grid, 1)
        -- TODO delete eaten chick to _chicks array
        _game.chicks_score = _game.chicks_score + 1 
    end
end

function check_direction_update()
    if (_snake.direction.x ~= 0 and _tempDirection.x ~= _snake.direction.x * -1) or (_snake.direction.y ~= 0 and _tempDirection.y ~= _snake.direction.y * -1)  then
        _snake.direction = _tempDirection
    end
end

-- CORE --

function love.load()
    _game.state.start_menu = true
    _game.state.game_running = false
    _game.state.game_over = false

    _snake:init_cell_positions(_grid.size)
    _grid:init_matrix(_snake)
    _chicks:add_chicks(_grid, 4)

    _tempDirection = _snake.direction
end

function love.update(dt)
    if _game.state.start_menu then
        if love.keyboard.isDown("space") then
            _game.state.start_menu = false
            _game.state.game_running = true
        end

    elseif _game.state.game_running then
        if love.keyboard.isDown("left") then
            _tempDirection = { x = -1, y = 0 }

        elseif love.keyboard.isDown("right") then
            _tempDirection = { x = 1, y = 0 }

        elseif love.keyboard.isDown("up") then
            _tempDirection = { x = 0, y = -1 }

        elseif love.keyboard.isDown("down") then
            _tempDirection = { x = 0, y = 1 }
        end

        _game.timer = _game.timer + dt

        if _game.timer > _game.refresh_delay then
            check_direction_update()
            check_next_position_state({ x = _snake.cell_positions[1].x + _snake.direction.x, y = _snake.cell_positions[1].y + _snake.direction.y })

            _game.timer = 0
        end
    end
end

function love.draw()
    if _game.state.start_menu then
        love.graphics.print("PRESS SPACE KEY")

    elseif _game.state.game_running then
        
        love.graphics.print(_game.chicks_score)

        _snake:draw(_game.window_scale)
        _chicks:draw(_game.window_scale)
        
    elseif _game.state.game_over then
        love.graphics.print("GAME OVER")
    end
end