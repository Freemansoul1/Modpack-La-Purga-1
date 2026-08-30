-- TimedActions\ISReadABook.lua
local originalISReadABookUpdate = ISReadABook.update

function ISReadABook:update(...)
	local readPages
	if self.item:getNumberOfPages() >= 1 then
		readPages = self.item:getAlreadyReadPages()
	end
	
	
	local result = originalISReadABookUpdate(self, ...)
	
	
	if readPages ~= nil then
		readPages = self.item:getAlreadyReadPages() - readPages
		if readPages >= 1 then
			local traitMultiplier
			if		self.character:HasTrait("FastReader") then
				traitMultiplier = 0.7
			elseif	self.character:HasTrait("SlowReader") then
				traitMultiplier = 1.3
			else
				traitMultiplier = 1.0
			end
			local bodyDamage = self.character:getBodyDamage()
			local sicknessMultiplier = math.min(1, math.max(0, ((75 - bodyDamage:getApparentInfectionLevel()) / 50)))
			
			
			local boredom = bodyDamage:getBoredomLevel()
			bodyDamage:setBoredomLevel(boredom - (boredom * (boredom < 25 and 0.05 or 0.1) * traitMultiplier * sicknessMultiplier))
			
			
			local unhappyness = bodyDamage:getUnhappynessLevel()
			bodyDamage:setUnhappynessLevel(unhappyness - (unhappyness * (unhappyness < 45 and 0.02 or 0.05) * traitMultiplier * sicknessMultiplier))
			
			
			local stats = self.character:getStats()
			local stress = stats:getStress() - stats:getStressFromCigarettes()
			stats:setStress(stress - (stress * (stress < 0.5 and 0.02 or 0.05) * traitMultiplier * sicknessMultiplier))
		end
	end
	
	
	return result
end
