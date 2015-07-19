local player = {}
local ch = require('chain')
local vo = require('vector_ops')

function player.new(world)

	local self = {}

	local body = love.physics.newBody(world, 300, 100, "kinematic")
	local shape = love.physics.newCircleShape(3)
	local fixture = love.physics.newFixture(body, shape)
	fixture:setUserData("Player") --Used to identify player in collisions


	local join
	local reinforce

	local position = {x = 300, y = 100}
	local velocity = {x = 0, y = 0}
	local target = {x = 300, y = 100}

	local chain = ch.new(world)

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
		love.graphics.setColor(220, 0, 220)
		x,y = body:getPosition()
		love.graphics.circle("fill", x,y, 3, 15)
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
		velocity = vo.scalarDiv(vo.subtract(target, {x=x1, y=y1}), 2)
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

	self.linkToChain()

	return self
end

return player