local chain = {}
local vo = require('vector_ops')

function chain.new(world)

	local self = {}
	local links = {}
	local world = world

	local link_radius = 3
	local link_distance = 10
	local endlink_radius = 15
	
	local link_sprites = { 
						   love.graphics.newImage("Sprites/Link_Low.png"),
						   love.graphics.newImage("Sprites/Link_Med.png"),
						   love.graphics.newImage("Sprites/Link_High.png"),
						   love.graphics.newImage("Sprites/Link_Full.png")
						 }

	local link_end_sprites = {
								love.graphics.newImage("Sprites/Link_End_Low.png"),
								love.graphics.newImage("Sprites/Link_End_Med.png"),	
								love.graphics.newImage("Sprites/Link_End_High.png"),
								love.graphics.newImage("Sprites/Link_End_Full.png")
							}

	local link_sprite_index = 4



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
				link.body:setLinearDamping(0.25)
			else
				link.shape = love.physics.newCircleShape(link_radius) 
				link.body:setLinearDamping(0.25)
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

			x,y = links[i].body:getPosition()

			if(i == #links) then
				drawtype = "fill"
				love.graphics.draw(link_end_sprites[link_sprite_index],  x - endlink_radius,y - endlink_radius)
			else
				love.graphics.draw(link_sprites[link_sprite_index], x - link_radius,y - link_radius)
			end
		end		

		love.graphics.print(#links, 100, 100)

	end

	function self.lengthenChain()

		newlink = {}
		x,y = links[1].body:getPosition();

		newlink.body = love.physics.newBody(world, x, y, "dynamic") --Create a physics body
		newlink.body:setLinearDamping(0.25)
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



	function self.setLinkSprite(index)
		
		link_sprite_index = index

		if(link_sprite_index < 1) then
			link_sprite_index = 1
		end
		
	end

	

	return self

end

return chain