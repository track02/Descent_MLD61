local chain = {}
local vo = require('vector_ops')

function chain.new(world)

	local self = {}
	local links = {}
	local world = world

	local link_radius = 3
	local link_distance = 10
	local endlink_radius = 15

	local target = {x = 0, y = 0}
	local velocity = {x = 0, y = 0}

	function self.generateLinks(segments, startx, starty)

		xpos = startx
		ypos = starty

		for i = 1, segments, 1 do

			link = {}

			link.body = love.physics.newBody(world, xpos, ypos, "dynamic")			
			
			if (i == segments) then
				link.shape = love.physics.newCircleShape(endlink_radius) --Ending link
				link.body:setLinearDamping(0.5)
			else
				link.shape = love.physics.newCircleShape(link_radius) 
				link.body:setLinearDamping(0.5)
			end

			link.fixture = love.physics.newFixture(link.body, link.shape) --Fix bodies to shapes

			if(i == segments) then
				link.fixture:setUserData("F") --Final link
			else
				link.fixture:setUserData("L") --Link
			end

			table.insert(links,link) 

			ypos = ypos + link_distance

		end

		self.linkChain()

	end

	function self.linkChain()


		for i = 2, #links, 1 do

			x1,y1 = links[i-1].body:getPosition()
			x2,y2 = links[i].body:getPosition()
			links[i-1].join = love.physics.newRopeJoint(links[i-1].body, links[i].body, x1, y1 , x2, y2, 10, false )

		end

	end


	function self.drawChain()


		drawtype = "line"

		for i = 1, #links, 1 do

			if(i == #links) then
				drawtype = "fill"
			end

			x,y = links[i].body:getPosition()
			love.graphics.setColor(220, 220, 220) -- set the drawing color to green for the ground
			love.graphics.circle(drawtype, x,y, links[i].shape:getRadius(), 10)

		end		

		for i = 1, #links -1, 1 do

			love.graphics.setColor(0, 0, 0) -- set the drawing color to green for the ground
			ax1, ay1, ax2, ay2 = links[i].join:getAnchors()
			love.graphics.circle("fill", ax1, ay1, 1, 10)
			love.graphics.circle("fill",ax2,ay2, 1, 10)

		end

		love.graphics.print(#links, 100, 100)

	end

	function self.lengthenChain()

		newlink = {}
		x,y = links[1].body:getPosition();

		newlink.body = love.physics.newBody(world, x, y, "dynamic") --Create a physics body
		newlink.body:setLinearDamping(0.1)
		newlink.shape = love.physics.newCircleShape(link_radius) -- Create a rectangle 600x50
		newlink.fixture = love.physics.newFixture(newlink.body, newlink.shape) --Fix rectangle to body
		newlink.fixture:setUserData("L") --Link

		links[1].body:setPosition(x,y+link_distance)

		newlink.join = love.physics.newRopeJoint(newlink.body, links[1].body, x, y, x, y+link_distance, link_distance, false )

		table.insert(links, 1, newlink)

		links[2].body:setType("dynamic")

	end

	function self.shortenChain()

		if(#links > 3) then

		x,y = links[1].body:getPosition();

		links[1].join:destroy()
		links[1].body:destroy()

		links[2].body:setType("dynamic")
		links[2].body:setPosition(x,y)

		table.remove(links, 1)

		end

	end

	function self.getLinks()
		return links
	end

	

	return self

end

return chain