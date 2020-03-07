Idle = class(
	function (idle, emoteIndex, minimumTime, priority)
		idle.emoteIndex = emoteIndex
		idle.minimumTime = minimumTime
		idle.priority = priority
	end
)

function Idle.Copy(savedIdle)
	return Idle(savedIdle.emoteIndex, savedIdle.minimumTime, savedIdle.priority)
end

function Idle:Play()
	PlayEmoteByIndex(self.emoteIndex)
end