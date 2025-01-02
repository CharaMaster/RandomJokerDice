SMODS.Atlas {
  -- Key for code to find it with
  key = "RandomJokerDice",
  -- The name of the file, for the code to pull the atlas from
  path = "JokerPic.png",
  -- Width of each sprite in 1x size
  px = 71,
  -- Height of each sprite in 1x size
  py = 95
}

SMODS.Atlas {
  key = "temp",
  path = "temp.png",
  px=71,
  py=95
}

SMODS.Atlas {
  key = "enhancements",
  path = "enhancements.png",
  px = 71,
  py = 95
}

local function is_end_of_round(context)
  return context.end_of_round
      and not context.game_over and not
      context.individual and not
      context.repetition and not
      context.retrigger_joker
end

SMODS.Joker {
  key = 'ragedice',
  loc_txt = {
    name = 'Rage Dice',
    text = {
      "Evert card give {X:mult,C:white} X#1# {} mult when card scored",
      "Gain {X:mult,C:white} X#2# {} mult per card scored",
      "Resets at end of the round",
      "{s:0.7, C:inactive}Code by CharaMaster"
    }
  },

  config = { extra = { xmult = 1, xmult_gain = 0.2 } },
  rarity = 3,
  atlas = 'RandomJokerDice',
  pos = { x = 0, y = 0 },
  soul_pos = { x = 1, y = 0 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
  end,

  calculate = function(self, card, context)
    if context.joker_main then
      return {
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
        Xmult_mod = card.ability.extra.xmult,
        card = card
      }
    end

    if context.individual and context.cardarea == G.play then
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = "RAGE"})
      card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
      return {
        message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } },
        x_mult = card.ability.extra.xmult,
        card = card,
      }
    end

    if is_end_of_round(context) and card.ability.extra.xmult > 1 then
      card.ability.extra.xmult = 1
      return {
        message = localize('k_reset'),
        colour = G.C.RED,
        card = card
      }
    end
  end
}

SMODS.Enhancement {
  key = "bounty",
  atlas = "enhancements",
  loc_txt = {
    name = "Bounty Card",
    text = {
      "{C:green}Bounty Dice",
      "has put a {C:attention}bounty",
      "on this card"
    }
  },
  weight = 0,
  config = {mult = 4, p_dollars = 6},
  overrides_base_rank = true
}

SMODS.Joker {
  key = "bountydice",
  loc_txt = {
    name = "Bounty Dice",
    text = {
      "When first hand is played, put a {C:attention}bounty",
      "on a {C:red}random card{} in hand",
      "When the card with a {C:attention}bounty{} is played,",
      "gives {C:red}+#1#{} Mult and {C:blue}+#2#{} Chips",
      "{s:0.7, C:inactive}Code by AmazinDooD"
    }
  },
  config = {extra = {mult = 4, chips = 50}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_mvan_bounty
    return {vars = {
    card.ability.extra.mult,
    card.ability.extra.chips
  }} end,
  rarity = 1,
  atlas = "temp",
  cost = 4,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and G.GAME.current_round.hands_played == 0 then
      math.randomseed(os.time()) --teehee
      local bounty_card = G.hand.cards[math.random(#G.hand.cards)]
      bounty_card:set_ability(G.P_CENTERS.m_mvan_bounty, nil, true)
      card:juice_up()
      card_eval_status_text(bounty_card, "extra", nil, nil, nil, {message="Bounty!"}) end
    if is_end_of_round(context) or context.selling_self then
      for k,v in ipairs(G.playing_cards) do
        if v.config.center == G.P_CENTERS.m_mvan_bounty then v:set_ability(G.P_CENTERS.c_base, nil, true) end
      end
    end
  end
}


SMODS.Joker{
  key = "solar_dice",
  loc_txt = {
    name = 'Solar Dice',
    text = {
      'Played {C:attention}3s, 5s, 7s, or 9s{}',
      'give {C:mult}+Mult{} corresponding with their {C:attention}rank{}',
      "{s:0.7, C:inactive}Code by Valajar"
    }
  },
  rarity = 2,
  atlas = 'temp',
  cost = 5,
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      local rank = context.other_card:get_id()
      if rank == 3 or rank == 5 or rank == 7 or rank == 9 then
        return {
          mult = rank, -- Use the rank of the card as the multiplier
          card = card
        }
      end
    end
  end
}



SMODS.Joker{
  key = "slingshotdice",
  loc_txt = {
    name = 'Slingshot Dice',
    text = {
        'Played {C:attention}Aces, 2s, 3s, 4s, or 5s{}',
        'give {X:mult,C:white}X#1#{} Mult when scored',
        "{s:0.7, C:inactive}Code by Valajar"
    }
  },
  rarity = 3,
  atlas = "temp", 
  cost = 10,
  unlocked = true,
  discovered = true,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  config = {extra = {x_mult = 1.5}},
  loc_vars = function(self, info_queue, card)
    return { vars = { self.config.extra.x_mult } }
  end,
  calculate = function(self, card, context)
      if context.individual and context.cardarea == G.play then
          if context.other_card:get_id() == 14 or context.other_card:get_id() == 2 or context.other_card:get_id() == 3 or context.other_card:get_id() == 4 or context.other_card:get_id() == 5 then
            return {
                x_mult = card.ability.extra.x_mult,
                card = card
              }
          end
      end
  end
}
