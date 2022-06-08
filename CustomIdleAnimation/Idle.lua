Idle = class(
	function (idle, emoteSlashName, minimumTime, priority)
		idle.emoteSlashName = emoteSlashName
		idle.minimumTime = minimumTime
		idle.priority = priority
	end
)

function Idle.Copy(savedIdle)
	return Idle(savedIdle.emoteSlashName, savedIdle.minimumTime, savedIdle.priority)
end

function Idle:Play()
	PlayEmoteByIndex(emoteBySlashNames[self.emoteSlashName].emoteIndex)
end