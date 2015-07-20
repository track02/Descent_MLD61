local enemies = {}
local vo = require('vector_ops')

function enemies.new(_world)

	local self = {}
	local enemyList = {}
	local maxEnemies = 1
	local target = {x = 0 , y = 0}
	local toDelete = {}

	function self.addEnemy(px, py)

		target.x = px
		target.y = py


		if(#enemyList < maxEnemies and math.random() > 0.75) then
	
			x1 = math.random(50, 550)
			y1 = math.random(50, 550)

			enemy = {}
			enemy.body = love.physics.newBody(world, x1, y1, "dynamic")
			enemy.shape = love.physics.newCircleShape(10)
			enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)
			enemy.fixture:setUserData("E"..x1 + y1) --Used to identify this enemy in collisions
			enemy.body:setLinearDamping(0.1)
			enemy.health = 3

			table.insert(enemyList, enemy)

		end
	end


	function self.drawEnemies()

		love.graphics.setColor(0, 0, 220)
		for i = 1, #enemyList, 1 do
			x,y = enemyList[i].body:getPosition()
			radius = enemyList[i].shape:getRadius()
			love.graphics.circle("fill", x,y, 10, 15)
		end

	end


	function self.updateEnemies()

		x2 = target.x
		y2 = target.y


		for i = 1, #enemyList, 1 do

			x1,y1 = enemyList[i].body:getPosition()

			--Distance to player
			xlength = (x1 - x2)
			ylength = (y1 - y2)
			r = math.sqrt((xlength * xlength) + (ylength * ylength))


			xratio = (xlength / r)
			yratio = (ylength / r)

			enemyList[i].body:applyForce(xratio * -400, yratio * -400)

		end

		self.cleanUp()

	end


	function self.enemyHit(id)

		enemyIndex = 0

		for i = 1, #enemyList, 1 do

			if (id == enemyList[i].fixture:getUserData()) then
				enemyIndex = i


				enemyList[i].health = enemyList[i].health - 1

				if(enemyList[i].health <= 0) then
					table.insert(toDelete, enemyIndex)
				end

			end

		end	


	end	

	function self.cleanUp()

		for i = 1, #toDelete, 1 do
			enemyList[i].body:destroy()
			table.remove(enemyList, i)
		end

		toDelete = {}
	end

	return self

end

return enemies