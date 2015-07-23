local audio = {}

function audio.new()

	local self = {}


	local collisionAudio = {
							love.audio.newSource("Music/EnemyStrongHit.wav"),
							love.audio.newSource("Music/EnemyWeakHit.wav"),
							love.audio.newSource("Music/EnemyWallHit.wav")
						}

	local bgm = love.audio.newSource("Music/MenuBGM.wav", "static")
	bgm:setLooping(true)

	function self.playCollision(id)
		collisionAudio[id]:play()
	end
	
	function self.playBGM()
		bgm:play()
	end

	function self.resumeBGM()
		bgm:resume()
	end

	function self.stopBGM()
		love.audio.pause()
	end



	return self
	

end




return audio