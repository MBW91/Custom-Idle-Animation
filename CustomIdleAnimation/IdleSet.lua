IdleSet = class(
	function (idleSet, title)
		idleSet.title = title
		idleSet.idles = {}
		idleSet.activeIdleIndex = 0
	end
)

function IdleSet.Copy(savedIdleSet)
	local self = IdleSet(savedIdleSet.title)
	for _, idle in pairs(savedIdleSet.idles) do
		table.insert(self.idles, Idle.Copy(idle))
	end
	return self
end

function IdleSet:Add(idle)
	table.insert(self.idles, idle)
end

function IdleSet:Remove(idle)
	local index = FindIndex(self.idles, idle)
	if (index ~= nil) then
		table.remove(self.idles, index)
		self.activeIdleIndex = 0
		self:SetActiveIdle()
	end
end

function IdleSet:Get(emoteIndex)
	for _, idle in pairs(self.idles) do
		if (idle.emoteIndex == emoteIndex) then
			return idle
		end
	end
end

function IdleSet:Start()
	self:Stop()

	if Length(self.idles) > 0 then
		self:SetActiveIdle()
	end
end

function IdleSet:Stop()
	EVENT_MANAGER:UnregisterForUpdate("IdleSetPlayer")
	EVENT_MANAGER:UnregisterForUpdate("IdleSetRandomizer")
end

function IdleSet:Update()
	if (not IsBusy()) then
		self.idles[self.activeIdleIndex]:Play()
	end
end

function IdleSet:SetActiveIdle()
	self:Stop()

	if (IsBusy()) then
		EVENT_MANAGER:RegisterForUpdate("IdleSetRandomizer", 1000, function() self:SetActiveIdle() end)
		return;
	end

	self.activeIdleIndex = self:GetRandomIdleIndex()
	local playTime = self.idles[self.activeIdleIndex]:GetPlayTime() * 1000
	self:Update()
	EVENT_MANAGER:RegisterForUpdate("IdleSetRandomizer", playTime, function() self:SetActiveIdle() end)
	EVENT_MANAGER:RegisterForUpdate("IdleSetPlayer", 1000, function() self:Update() end)
end

function IdleSet:GetRandomIdleIndex()
	if (Length(self.idles) == 1) then
		return 1
	end

	local randMax = 0
	local idlesCount = Length(self.idles)
	for i=1, idlesCount do
		if (i ~= self.activeIdleIndex) then
			randMax = randMax + self.idles[i].priority
		end
	end

	local rand = math.random(randMax)
	local puffer = 0
	for i=1, idlesCount do
		if (i ~= self.activeIdleIndex) then
			puffer = puffer + self.idles[i].priority
			if rand <= puffer then
				puffer = i
				break
			end
		end
	end
	
	return puffer
end