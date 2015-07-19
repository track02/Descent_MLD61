local enemies = {}
local vo = require('vector_ops')

function enemies.new(_world)

	local self = {}
	local enemyList = {}
	local maxEnemies = 1
	local target = {x = 0 , y = 0}



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
			enemy.fixture:setUserData("Enemy" .. x1)
			enemy.body:setLinearDamping(0.1)

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

		toRemove = {}
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

	end

	return self

end

return enemies