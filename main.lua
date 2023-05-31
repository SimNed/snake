local _game = require 'game'

local _snake = require 'snake'
local _grid = require 'grid'
local _chicks = {}

local _tempDirection = {}

--- FUNCTIONS ---

function add_chicks(chicksNumber)
    for i = 1, chicksNumber do
        local chick_position = generate_random_free_position()
        table.insert(_chicks, chick_position)
        _grid.matrix[chick_position.x][chick_position.y] = _grid.cell_id.chick
    end
end

function generate_random_free_position()
    math.randomseed( os.time() )

    local random_position = { x = math.random(0, _grid.size), y = math.random(0, _grid.size) }
    
    while _grid.matrix[random_position.x][random_position.y] ~= _grid.cell_id.free do
        random_position =  { x = math.random(0, _grid.size), y = math.random(0, _grid.size) }
    end

    return random_position
end

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
        add_chicks(1)
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

    _tempDirection = _snake.direction
    
    add_chicks(4)
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
        love.graphics.setColor(_snake.color)
        love.graphics.print(_game.chicks_score)

        for i = 1, #_snake.cell_positions do
            love.graphics.rectangle(
                'fill',
                _snake.cell_positions[i].x * _game.window_scale,
                _snake.cell_positions[i].y * _game.window_scale,
                _game.window_scale,
                _game.window_scale
            )
        end

        love.graphics.setColor({1,1,0,1})

        for i = 1, #_chicks do
            love.graphics.rectangle(
                'fill',
                _chicks[i].x * _game.window_scale,
                _chicks[i].y * _game.window_scale,
                _game.window_scale,
                _game.window_scale
            )
        end

    elseif _game.state.game_over then
        love.graphics.print("GAME OVER")
    end
end