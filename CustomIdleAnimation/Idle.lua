Idle = class(
	function (idle, emoteIndex, minimumTime, maximumTime, priority)
		idle.emoteIndex = emoteIndex
		idle.minimumTime = minimumTime
		idle.maximumTime = maximumTime
		idle.priority = priority
	end
)

function Idle.Copy(savedIdle)
	return Idle(savedIdle.emoteIndex, savedIdle.minimumTime, savedIdle.maximumTime, savedIdle.priority)
end

function Idle:Play()
	PlayEmoteByIndex(self.emoteIndex)
end

function Idle:GetPlayTime()
	return self.minimumTime + Random(self.maximumTime - self.minimumTime)
end