local player = {}
local ch = require('chain')
local vo = require('vector_ops')

function player.new(world)

	local self = {}
	local body = love.physics.newBody(world, 300, 100, "dynamic")
	local shape = love.physics.newCircleShape(16)
	local fixture = love.physics.newFixture(body, shape)
	local mass = 1000

	fixture:setUserData("P") --Used to identify player in collisions
	body:setGravityScale(0.5)
	body:setMass(mass)

	local join
	local reinforce
	local position = {x = 300, y = 100}
	local velocity = {x = 0, y = 0}
	local target = {x = 300, y = 100}
	local chain = ch.new(world)

	local life = 5

	local sprites = { love.graphics.newImage("Sprites/Player_Destroyed.png"),
					  love.graphics.newImage("Sprites/Player_Injured_3.png"),
					  love.graphics.newImage("Sprites/Player_Injured_2.png"),
					  love.graphics.newImage("Sprites/Player_Injured_1.png"),
					  love.graphics.newImage("Sprites/Player.png")}

	chain.generateLinks(9, 300, 100)


	function self.lengthenChain()
		join:destroy()
		chain.lengthenChain()		
		self.linkToChain()
	end

	function self.shortenChain()
		join:destroy()
		chain.shortenChain()		
		self.linkToChain()
	end

	function self.drawPlayer()
		chain.drawChain()
		x,y = body:getPosition() --Player Center
		love.graphics.draw(sprites[life],x-16,y-16)
		love.graphics.circle("line",x,y,16,10)
	end

	function self.updatePosition(x_update,y_update)
		body:setLinearVelocity(velocity.x, velocity.y)
	end

	function self.setTarget(x,y)
		target.x = x
		target.y = y
		self.calcVelocity()
	end

	function self.calcVelocity()
		x1,y1 = body:getPosition()
		velocity = vo.scalarDiv(vo.subtract(target, {x=x1, y=y1}), 1)
	end

	function self.linkToChain()
		links = chain.getLinks()
		x1,y1 = body:getPosition()
		x2,y2 = links[1].body:getPosition()
		join = love.physics.newRevoluteJoint(body, links[1].body, x1, y1, x2, y2, false )
		--join:setMaxMotorTorque(-5)
		--join:setMotorEnabled(true)
	end

	function self.getPosition()
		return body:getPosition()
	end

	function self.getJoinInfo()
		--return join:getJointSpeed()
	end

	function self.playerHit()
		if(life > 1) then
			life = life - 1
			chain.setLinkSprite(life - 1)
			--Flag for game over

		end
	end

	function self.playerLife()
		return life
	end

	self.linkToChain()

	return self
end

return player