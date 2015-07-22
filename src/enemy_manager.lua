local enemies = {}
local vo = require('vector_ops')

function enemies.new(_world)

	local self = {}
	local enemyList = {}
	local maxEnemies = 1
	local target = {x = 0 , y = 0}
	local toDelete = {}
	local enemyRadius = 16

	local liveSprites_set1 =  {
						  love.graphics.newImage("Sprites/EnemyLow_1.png"),
  						  love.graphics.newImage("Sprites/EnemyMed_1.png"),
						  love.graphics.newImage("Sprites/EnemyFull_1.png"),
						 }


	local liveSprites_set2 = {
 						  love.graphics.newImage("Sprites/EnemyLow_2.png"),
  						  love.graphics.newImage("Sprites/EnemyMed_2.png"),
						  love.graphics.newImage("Sprites/EnemyFull_2.png"),
							 }


	local liveSprites_set3 = {
 						  love.graphics.newImage("Sprites/EnemyLow_3.png"),
  						  love.graphics.newImage("Sprites/EnemyMed_3.png"),
						  love.graphics.newImage("Sprites/EnemyFull_3.png"),
						   }

	local liveSprites_set4 = {
 						      love.graphics.newImage("Sprites/EnemyLow_4.png"),
  						      love.graphics.newImage("Sprites/EnemyMed_4.png"),
						      love.graphics.newImage("Sprites/EnemyFull_4.png"),
							 }

	local liveSprites = {liveSprites_set1, liveSprites_set2, liveSprites_set3,liveSprites_set4}


	local deathSprites = {
						  love.graphics.newImage("Sprites/EnemyDeath1.png"),
						  love.graphics.newImage("Sprites/EnemyDeath2.png"),
						  love.graphics.newImage("Sprites/EnemyDeath3.png"),
						  love.graphics.newImage("Sprites/EnemyDeath4.png"),
						  love.graphics.newImage("Sprites/EnemyDeath5.png"),
						  love.graphics.newImage("Sprites/EnemyDeath6.png"),
						  love.graphics.newImage("Sprites/EnemyDeath7.png"),
						 }

	local noDeathFrames = 7

	function self.addEnemy(px, py, pd)

		target.x = px
		target.y = py

		--Use depth as a difficulty multiplyer
		if((pd / 1500) > maxEnemies) then
			maxEnemies = maxEnemies + 1
		end



		if(#enemyList < maxEnemies and math.random() > 0.99) then
	
			x1 = math.random(100, 900)
			y1 = math.random(850, 900) --Spawn from bottom, offscreen

			enemy = {}
			enemy.body = love.physics.newBody(world, x1, y1, "dynamic")
			enemy.shape = love.physics.newCircleShape(enemyRadius)
			enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)
			enemy.fixture:setUserData("E"..x1 + y1) --Used to identify this enemy in collisions
			enemy.body:setLinearDamping(0.1)
			enemy.health = 3
			enemy.force = -1 * (math.random(900 + (pd/5), 1000 + (pd/5)))
			enemy.deathFrame = 1
			enemy.spriteSet = math.random(1,4)
			enemy.sprite = liveSprites[enemy.spriteSet][enemy.health]
			table.insert(enemyList, enemy)

		end
	end


	function self.drawEnemies()

		for i = 1, #enemyList, 1 do
			x,y = enemyList[i].body:getPosition()
			radius = enemyList[i].shape:getRadius()
			love.graphics.draw(enemyList[i].sprite, x - radius, y - radius)
			--love.graphics.print("ID:"..enemyList[i].fixture:getUserData(), x + (i*10), y + (i*10))
		end
	end


	function self.updateEnemies()

		x2 = target.x
		y2 = target.y

		for i = 1, #enemyList, 1 do

			if(enemyList[i].health <= 0) then

				--If an enemy is dead, play death animation then clean up
				--Set sprite 
				enemyList[i].sprite = deathSprites[enemyList[i].deathFrame]
				enemyList[i].deathFrame = enemyList[i].deathFrame + 1

				if(enemyList[i].deathFrame >= noDeathFrames) then
					table.insert(toDelete, i)
				end
			
			end

		end

		self.cleanUp()

		for i = 1, #enemyList, 1 do

			x1,y1 = enemyList[i].body:getPosition()

			--Distance to player
			xlength = (x1 - x2)
			ylength = (y1 - y2)
			r = math.sqrt((xlength * xlength) + (ylength * ylength))

			xratio = (xlength / r)
			yratio = (ylength / r)

			enemyList[i].body:applyForce(xratio * enemyList[i].force, yratio * enemyList[i].force)
			
		end


	end


	function self.enemyHit(id, hitplayer)

		
		for i = 1, #enemyList, 1 do

			if (id == enemyList[i].fixture:getUserData()) then
				enemyIndex = i

				if(hitplayer) then
					enemyList[i].health = 0
				else
					enemyList[i].health = enemyList[i].health - 1
				end

				if(enemyList[i].health <= 0 or enemyList[i].health >= 3) then
					enemyList[i].sprite = liveSprites[enemyList[i].spriteSet][1]
				else
					enemyList[i].sprite = liveSprites[enemyList[i].spriteSet][enemyList[i].health]
				end
			end
		end	

	end	

	function self.cleanUp()

		for i = 1, #toDelete, 1 do
			enemyList[toDelete[i]].body:destroy()
			table.remove(enemyList, toDelete[i])
			toDelete[i] = nil
		end
	end

	return self


end

return enemies