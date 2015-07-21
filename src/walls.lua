local walls = {}

function walls.new(world)

	local self = {}

	local leftWall = {}
	local rightWall = {}

	leftWall.body = love.physics.newBody(world, 50, 400, "static") --Make the wall 80x800
	leftWall.shape = love.physics.newRectangleShape(95, 800)
	leftWall.fixture = love.physics.newFixture(leftWall.body, leftWall.shape)
	leftWall.fixture:setUserData("W") --Used to identify wall in collisions
	leftWall.sprite = love.graphics.newImage("Sprites/LeftWall.png")

	rightWall.body = love.physics.newBody(world, 974, 400, "static") --Make the wall 80x800
	rightWall.shape = love.physics.newRectangleShape(95, 800)
	rightWall.fixture = love.physics.newFixture(rightWall.body, rightWall.shape)
	rightWall.fixture:setUserData("W") --Used to identify wall in collisions
	rightWall.sprite = love.graphics.newImage("Sprites/RightWall.png")





	function self.drawWalls()
		love.graphics.draw(leftWall.sprite, 0,0)
		love.graphics.draw(rightWall.sprite, 924, 0)
	end


	return self
end

return walls