--- STEAMODDED HEADER
--- MOD_NAME: Inspectors Inventory
--- MOD_ID: InspectorsInventory
--- MOD_AUTHOR: [InspectorB]
--- MOD_DESCRIPTION: This Mod is a collection of Inspector's Misc Items
--- PREFIX: inv
--- BADGE_COLOUR: 708b91
--- DEPENDENCIES:Cryptid>=0.5.3<=0.5.5

----------------------------------------------
------------MOD CODE -------------------------
---
---
---
---

SMODS.Atlas {
	key = "invatlas",
	path = "invatlas.png",
	px = 71,
	py = 95
}

SMODS.Enhancement {
	key = "shitty",
	atlas = "invatlas",
	pos = {x = 0, y = 0 }, 
	config = {bonus = 1, mult = 0.01},
	replace_base_card = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {card and self.config.bonus or 1, card and self.config.mult or 0.01}}
	end,
	no_rank = true,
	any_suit = true
}

SMODS.Consumable { 
	object_type = "Consumable",
	set = "Tarot",
	name = "number2",
	key = "number2",
	order = 2,
	pos = { x = 1, y = 0 },
	config = { mod_conv = "m_inv_shitty", max_highlighted = 2, extra = {money = 20} },
	atlas = "invatlas",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_inv_shitty

		return { vars = { card and self.config.max_highlighted or 2, card and self.config.extra.money or 20 } }
	end,
	use = function(self, card, area, copier)
		--loop through selected highlighted cards
		for i = 1, #G.hand.highlighted do
			local highlighted = G.hand.highlighted[i]
			--play sound
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					highlighted:juice_up(0.3, 0.5)
					return true
				end,
			}))

			--flip card
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()	
					if highlighted then				
						highlighted:flip()
					end
					return true
				end,
			}))

			--update enhancement
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					if highlighted then
						highlighted:set_ability(G.P_CENTERS.m_inv_shitty, true, nil)						
					end
					return true
				end,
			}))

			--flip again
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					if highlighted then
						highlighted:flip()
					end
					return true
				end,
			}))
		end

		--Get Money
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.6,
			func = function()
				ease_dollars(self.config.extra.money)
				return true
			end
		}))
		delay(0.5)

		--unselect cards
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end,
		}))
	end,
	can_use = function(self, card)
		local usable = false
		if #G.hand.highlighted == card.ability.max_highlighted then
			usable = true
		end

		return usable
	end,
	
}