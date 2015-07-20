local _chain = require('chain')
local _player = require('player')
local _enemyList = require('enemy_manager')

function love.conf(t)

	t.window.width = 1024
	t.window.height = 800
	t.console = true

end

function love.load()
	love.window.setMode(1024,800, {vsync=true})
	love.keyboard.setKeyRepeat(true)

	love.physics.setMeter(32) -- One meter is 32 px

	world = love.physics.newWorld(0, 9.81*32, true) -- Horizontal gravity 0, Vertical gravity 9.81, allow bodies to sleep
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)

	player = _player.new(world)

	enemies = _enemyList.new(world)

	love.graphics.setBackgroundColor(104,136,248)

	textA = ""
	textB = ""

end

function love.update(dt)
	player.updatePosition()
	enemies.addEnemy(player.getPosition())
	enemies.updateEnemies()

	--Important! -> break down update intervals into several small steps
	--One large interval will break joints due to large generated forces
	--Split this up and box2D can limit forces on joints
	world:update(dt/3) 
	world:update(dt/3)
	world:update(dt/3)


end

function love.keypressed(key, isrepeat)

	if love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
		player.shortenChain()
	end

	if love.keyboard.isDown("down") then --press the up arrow key to set the ball in the air
		player.lengthenChain()
	end

end

function love.keyreleased(key)

end

function love.mousemoved(x,y,dx,dy)
		player.setTarget(x,y)
end

function love.draw()

	love.graphics.setColor(220, 220, 220) -- set the drawing color to green for the ground
	player.drawPlayer()
	enemies.drawEnemies()
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
	love.graphics.print(textA, 10,20)
	love.graphics.print(textB, 10,30)

end


--a is first fixture object
--b is second fixture object
--coll is contact object
function beginContact(a, b, coll)

	x,y = coll:getNormal()
	textA = a:getUserData() 
	textB = b:getUserData()

	-- _E_nemy colliding with _F_inal link chain
	if(a:getUserData():sub(1,1) == "E" and b:getUserData():sub(1,1) == "F") then
		textA = "DESTROYING A"
		enemies.removeEnemy(a:getUserData())
	elseif(b:getUserData():sub(1,1) == "E" and a:getUserData():sub(1,1) == "F") then
		textB = "DESTROYING B"
		enemies.removeEnemy(b:getUserData())
	end
 
end
 
function endContact(a, b, coll)
 
end
 
function preSolve(a, b, coll)
 
end
 
function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
 
end
