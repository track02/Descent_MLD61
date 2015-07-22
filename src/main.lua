local _chain = require('chain')
local _player = require('player')
local _enemyList = require('enemy_manager')
local _walls = require('walls')

function love.conf(t)

	t.window.width = 1024
	t.window.height = 800
	t.console = true

end

function love.load()

	gameState = {mainMenu = true, gameStart = false, gameOver = false}

	love.window.setMode(1024,800, {vsync=true})
	love.keyboard.setKeyRepeat(false)
	love.physics.setMeter(32) -- One meter is 32 px

	world = love.physics.newWorld(0, 9.81*32, true) -- Horizontal gravity 0, Vertical gravity 9.81, allow bodies to sleep
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)

	player = _player.new(world)
	enemies = _enemyList.new(world)
	walls = _walls.new(world)

	love.graphics.setNewFont("Fonts/White Submarine.ttf", 15)
	mainMenu = love.graphics.newImage("Sprites/MainMenu.png")
	gameOver = love.graphics.newImage("Sprites/GameOver.png")

	Collision = ""

end

function love.update(dt)

 if(gameState.gameStart) then

	player.updatePosition()
	px,py = player.getPosition()
	enemies.addEnemy(px,py, player.getDepth())
	enemies.updateEnemies()

	--Important! -> break down update intervals into several small steps
	--One large interval will break joints due to large generated forces
	--Split this up and box2D can limit forces on joints
	world:update(dt/3) 
	world:update(dt/3)
	world:update(dt/3)


	if(player.playerLife() <= 1) then
		gameState.gameStart = false
		gameState.gameOver = true
	end


end


end

function love.keypressed(key, isrepeat)

	if love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
		player.shortenChain()
	end

	if love.keyboard.isDown("down") then --press the up arrow key to set the ball in the air
		player.lengthenChain()
	end

	if(love.keyboard.isDown("return")) then

		if(gameState.mainMenu) then
			gameState.mainMenu = false
			gameState.gameStart = true
		elseif(gameState.gameOver) then
			love.load()
		end

	end
end


function love.mousemoved(x,y,dx,dy)
		player.setTarget(x,y)
end

function love.draw()

	if(gameState.mainMenu) then
		love.graphics.draw(mainMenu,0,0)
	elseif(gameState.gameOver) then

		love.graphics.draw(gameOver,0,0)
		player.drawPlayer()
		enemies.drawEnemies()
		love.graphics.print("Final Depth: " .. player.getDepth() .. "m", 475,0)


	else
		love.graphics.setColor(255, 255, 255) -- set the drawing color to green for the ground
		walls.drawWalls()
		player.drawPlayer()
		enemies.drawEnemies()
		love.graphics.setColor(255, 255, 255) -- set the drawing color to green for the ground
		love.graphics.print("Depth: " .. player.getDepth() .. "m", 475,0)
		--love.graphics.print("COLLISION WITH: " .. Collision, 450,15)
	end

end

--a is first fixture object
--b is second fixture object
--coll is contact object
function beginContact(a, b, coll)

	x,y = coll:getNormal()
	

	-- _E_nemy colliding with _F_inal link chain
	if(a:getUserData():sub(1,1) == "E" and b:getUserData():sub(1,1) == "F" and math.abs(b:getBody():getLinearVelocity()) > 400) then
		--enemies.enemyHit(a:getUserData(),false)
		--Collision = a:getUserData()
	elseif(b:getUserData():sub(1,1) == "E" and a:getUserData():sub(1,1) == "F" and math.abs(a:getBody():getLinearVelocity()) > 400) then
		enemies.enemyHit(b:getUserData(), false)
		Collision = b:getUserData()
	end
 
 	--_E_nemy colliding with _W_all
	if(a:getUserData():sub(1,1) == "E" and b:getUserData():sub(1,1) == "W" and math.abs(a:getBody():getLinearVelocity()) > 400) then
		enemies.enemyHit(a:getUserData())
	elseif(b:getUserData():sub(1,1) == "E" and a:getUserData():sub(1,1) == "W" and math.abs(b:getBody():getLinearVelocity()) > 400) then
		enemies.enemyHit(b:getUserData())
	end

	-- _E_nemy colliding with _P_layer
	if(a:getUserData():sub(1,1) == "E" and b:getUserData():sub(1,1) == "P") then
		--player.playerHit()
		--enemies.enemyHit(a:getUserData(), true)
	--	Collision = a:getUserData()
	elseif(b:getUserData():sub(1,1) == "E" and a:getUserData():sub(1,1) == "P") then
		enemies.enemyHit(b:getUserData(), true)
		player.playerHit()
		Collision = b:getUserData()
	end
 

end
 
function endContact(a, b, coll) 
end
 
function preSolve(a, b, coll) 
end
 
function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end