zeus_r = class({})
LinkLuaModifier("modifier_zeus_r", "abilities/zeus/modifier_zeus_r", LUA_MODIFIER_MOTION_NONE)

function zeus_r:OnSpellStart()
	local hero = self:GetCaster().hero
	local target = self:GetCursorPosition()
	local ability = self

	hero:EmitSound("Hero_Zuus.GodsWrath.PreCast")

	Timers:CreateTimer(1.6, 
		function()
			GridNav:DestroyTreesAroundPoint(target, 256, true)
			
			local particle = ImmediateEffect("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_POINT)
			ParticleManager:SetParticleControl(particle, 0, target)
			ParticleManager:SetParticleControl(particle, 1, target + Vector(0, 0, 2000))

			particle = ImmediateEffect("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_groundfx_crack.vpcf", PATTACH_POINT)
			ParticleManager:SetParticleControl(particle, 3, target)

			Spells:AreaModifier(hero, ability, "modifier_zeus_r", { duration = 4.5 }, target, 256,
				function (hero, target)
					return hero ~= target
				end
			)

			Spells:AreaDamage(hero, target, 256,
				function (target)
					local to = target:GetPos()
					local particle = ImmediateEffect("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN)
					ParticleManager:SetParticleControl(particle, 0, Vector(to.x, to.y, to.z + 64))
					ParticleManager:SetParticleControl(particle, 1, to)
				end
			)

			EmitSoundOnLocationWithCaster(target, "Hero_Zuus.GodsWrath.Target", nil)
		end
	)
end

function zeus_r:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end