local _game = require 'game'

local _snake = require 'snake'
local _grid = require 'grid'
local _chicks = require 'chicks'

local _tempDirection = {}

-- CORE --

function love.load()
    _game.state.start_menu = true
    _game.state.game_running = false
    _game.state.game_over = false

    _snake:init_cell_positions(_grid.size)
    _grid:init_matrix(_snake)
    _chicks:add_chicks(_grid, 4)

    _game.temp_direction = _snake.direction
end

function love.update(dt)
    if _game.state.start_menu then
        if love.keyboard.isDown("space") then
            _game.state.start_menu = false
            _game.state.game_running = true
        end

    elseif _game.state.game_running then
        if love.keyboard.isDown("left") then
            _game.temp_direction = { x = -1, y = 0 }

        elseif love.keyboard.isDown("right") then
            _game.temp_direction = { x = 1, y = 0 }

        elseif love.keyboard.isDown("up") then
            _game.temp_direction = { x = 0, y = -1 }

        elseif love.keyboard.isDown("down") then
            _game.temp_direction = { x = 0, y = 1 }
        end

        _game.timer = _game.timer + dt

        if _game.timer > _game.refresh_delay then
            local next_position = { x = _snake.cell_positions[1].x + _snake.direction.x, y = _snake.cell_positions[1].y + _snake.direction.y }
            _game:check_direction_update(_snake)
            _game:check_next_position_state(next_position, _grid, _snake, _chicks)
            _game.timer = 0
        end
    end
end

function love.draw()
    if _game.state.start_menu then
        _game:draw_start_menu()

    elseif _game.state.game_running then
        _game:draw_score()
        _snake:draw(_game.window_scale)
        _chicks:draw(_game.window_scale)
        
    elseif _game.state.game_over then

        _game.draw_game_over_menu()
    end
end