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
  px = 71,
  py = 95
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
  config = { extra = { xmult = 1, xmult_gain = 0.2, odds = 2 } },
  rarity = 3,
  atlas = 'RandomJokerDice',
  pos = { x = 0, y = 0 },
  soul_pos = { x = 1, y = 0 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
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
      if pseudorandom('ragedice') < G.GAME.probabilities.normal / card.ability.extra.odds then
        card_eval_status_text(card, 'extra', nil, nil, nil, { message = "RAGE" })
        card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
      end
      return {
        message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } },
        x_mult = card.ability.extra.xmult,
        card = card,
      }
    end

    if context.end_of_round
        and not context.game_over and not
        context.individual and not
        context.repetition and not
        context.retrigger_joker
        and card.ability.extra.xmult > 0.1 then
      card.ability.extra.xmult = 1
      card.ability.extra.odds = 2
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
  weight = 0,
  config = { mult = 4, p_dollars = 6 },
  overrides_base_rank = true
}

SMODS.Joker {
  key = "bountydice",
  config = { extra = { mult = 4, chips = 50, bounty_enhancement = G.P_CENTERS.c_base } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_rjd_bounty
    return {vars = {card.ability.extra.mult, card.ability.extra.chips}}
  end,
  rarity = 1,
  atlas = "temp",
  cost = 4,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and G.GAME.current_round.hands_played == 0 then
      math.randomseed(os.time()) --teehee
      local bounty_card = G.hand.cards[math.random(#G.hand.cards)]
      card.ability.extra.bounty_enhancement = bounty_card.config.center
      bounty_card:set_ability(G.P_CENTERS.m_rjd_bounty, nil, true)
      card:juice_up()
      card_eval_status_text(bounty_card, "extra", nil, nil, nil, { message = "Bounty!" })
    end
    if is_end_of_round(context) or context.selling_self then
      for k, v in ipairs(G.playing_cards) do
        if v.config.center == G.P_CENTERS.m_rjd_bounty then v:set_ability(card.ability.extra.bounty_enhancement, nil, true) end
      end
    end
  end
}


SMODS.Joker {
  key = "solardice",
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



SMODS.Joker {
  key = "slingshotdice",
  rarity = 2,
  atlas = "temp",
  cost = 10,
  unlocked = true,
  discovered = true,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  config = { extra = { x_mult = 1.25 } },
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


SMODS.Joker {
  key = "poisondice",
  rarity = 1,
  atlas = "temp",
  unlocked = true,
  discovered = true,
  cost = 6,
  blueprint_compat = false,
  config = { extra = 0.97 },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function()
          G.GAME.blind.chips = math.floor(G.GAME.blind.chips * card.ability.extra)
          G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

          local chips_UI = G.hand_text_area.blind_chips
          G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
          G.HUD_blind:recalculate()
          chips_UI:juice_up()

          if not silent then play_sound('chips2') end
          return true
        end
      }))
    end
  end,
}

SMODS.Joker {
  key = "mimicdice",
  rarity = 2,
  atlas = "temp",
  cost = 6,
  unlocked = true,
  discovered = true,
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  config = { extra = { repetitions = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.repetitions } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only then
      if context.other_card.ability.name == 'Wild Card' then
        return {
          message = 'Again!',
          repetitions = card.ability.extra.repetitions,
          card = context.other_card
        }
      end
    end
  end
}

SMODS.Joker {
  key = "brokendice",
  rarity = 1,
  atlas = "temp",
  cost = 4,
  config = { extra = { chips = 40, bonus_card = nil } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
  end,
  calculate = function(self, card, context)
    if context.before then
      card.ability.extra.bonus_card = math.random(#context.full_hand)
      card_eval_status_text(context.full_hand[card.ability.extra.bonus_card], "extra", nil, nil, nil, { message =
      "Broken!" })
    else
      if context.individual and context.cardarea == G.play then
        if context.other_card == context.full_hand[card.ability.extra.bonus_card] then
          return {
            message = localize { type = 'variable', key = "a_chips", vars = { card.ability.extra.chips } },
            chips = card.ability.extra.chips,
            card = card,
          }
        end
      end
    end
  end
}

SMODS.Joker {
  key = "summoningdice",
  rarity = 2,
  atlas = "temp",
  cost = 6,
  config = { extra = { discard_req = 15, discards_left = 15 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.discard_req, card.ability.extra.discards_left } }
  end,
  calculate = function(self, card, context)
    if context.discard then
      card.ability.extra.discards_left = card.ability.extra.discards_left - 1
      if card.ability.extra.discards_left ~= 0 then
        return {
          delay = 0.2,
          message = card.ability.extra.discards_left .. " Remaining",
          colour = G.C.RED,
          card = card
        }
      else
        -- 99% of this is copied from Certificate
        G.E_MANAGER:add_event(Event({
          func = function()
            local enhancement = SMODS.poll_enhancement { type_key = "sujjjjjjjjjjjjjjmmoning_dice", guaranteed = true }
            :lower()
            local _card = create_playing_card({
              front = pseudorandom_element(G.P_CARDS, pseudoseed('summoning')),
              center = G.P_CENTERS[enhancement]
            }, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
            G.GAME.blind:debuff_card(_card)
            G.hand:sort()
            card:juice_up()
            return true
          end
        }))
        card.ability.extra.discards_left = card.ability.extra.discard_req
        return {
          message = "Summoned!",
          colour = G.C.CHIPS,
          card = card,
          playing_cards_created = { true }
        }
      end
    end
  end
}

SMODS.Joker {
  key = "stardice",
  rarity = 3,
  atlas = "temp",
  config = {extra = {jokers = {nil, nil}}},
  calculate = function(self, card, context)
    if context.before then
      repeat
        card.ability.extra.jokers[1] = G.jokers.cards[math.random(#G.jokers.cards)]
        card.ability.extra.jokers[2] = G.jokers.cards[math.random(#G.jokers.cards)]
      until card.ability.extra.jokers[2] ~= card.ability.extra.jokers[1] and
      card.ability.extra.jokers[1] ~= card and 
      card.ability.extra.jokers[2] ~= card

      card.ability.extra.jokers[1]:juice_up()
      card.ability.extra.jokers[2]:juice_up()
      card_eval_status_text(card, "extra", nil, nil, nil, { message = "Starred!" })
    end
    if context.retrigger_joker_check and not context.retrigger_joker and
    (card.ability.extra.jokers[1] == context.other_card or
    card.ability.extra.jokers[2] == context.other_card) then

      return {
        message = localize("k_again_ex"),
        repetitions = 1,
        card = card
      }
    end
  end
}

SMODS.Joker {
  key = "combodice",
  rarity = 3,
  atlas = "temp",
  blueprint_compat = true,
  config = {extra = {hand = "High Card", times_played = 0}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.hand, card.ability.extra.times_played}}
  end,
  calculate = function(self, card, context)
    if context.before then
      if card.ability.extra.hand ==  G.FUNCS.get_poker_hand_info(context.full_hand) and card.ability.extra.times_played == 1 then
        card.ability.extra.times_played = 0
        return {
          message = localize("k_level_up_ex"),
          level_up = true,
          card = context.blueprint_card or card
        }
      end
      card.ability.extra.hand = G.FUNCS.get_poker_hand_info(context.full_hand)
      card.ability.extra.times_played = 1
      if not context.blueprint then card_eval_status_text(card, "extra", nil, nil, nil, {message = card.ability.extra.times_played.."/2"}) end
    end
  end
}

SMODS.Joker {
  key = "holysworddice",
  rarity = 3,
  atlas = "temp",
  config = {extra = {chance = 20, blind_size = 0.8}},
  loc_vars = function (self, info_queue, card)
    return {vars = {
      card.ability.extra.chance,
      100 - card.ability.extra.blind_size * 100,
      G.GAME.probabilities.normal
    }}
  end,
  calculate = function(self, card, context)
    if context.before and pseudorandom('holysworddice') < G.GAME.probabilities.normal / card.ability.extra.chance then
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function()
          G.GAME.blind.chips = math.floor(G.GAME.blind.chips * card.ability.extra.blind_size)
          G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

          local chips_UI = G.hand_text_area.blind_chips
          G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
          G.HUD_blind:recalculate()
          chips_UI:juice_up()

          if not silent then play_sound('chips2') end
          return true
        end
      }))
    end
  end
}

SMODS.Joker {
  key = "winddice",
  rarity = 1,
  atlas = "temp",
  config = {extra = {mult = 7, prefix = "j_rjd_"}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {
      key = "dice_def",
      set = "Other"
    }
    return {vars={card.ability.extra.mult}}
  end,
  calculate = function(self, card, context)
    if context.other_joker then
      if context.other_joker.config.center_key:sub(1,#card.ability.extra.prefix) == card.ability.extra.prefix then
        G.E_MANAGER:add_event(Event({
          func = function()
            context.other_joker:juice_up(0.5, 0.5)
            return true
          end
        }))
        return {
          message = localize{type="variable",key="a_mult",vars={card.ability.extra.mult}},
          mult_mod = card.ability.extra.mult,
        }
      end
    end
  end
}

SMODS.Joker {
  key = "mutationdice",
  rarity = 3,
  atlas = "temp",
  cost = 10,
  unlocked = true,
  discovered = true,
  eternal_compat = false,
  blueprint_compat = false,
  perishable_compat = true,
  config = { extra = {} },
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.selling_self and not context.blueprint and #G.hand.highlighted == 1 then
      local valid_cards = {}
      local selected_card = G.hand.highlighted[1]
      if #G.playing_cards > 1 then
        for i = 1, #G.playing_cards do
          if G.playing_cards[i] ~= selected_card then
            table.insert(valid_cards, i)
          end
        end
        for i = #valid_cards, 2, -1 do
          local j = math.random(1, i)
          valid_cards[i], valid_cards[j] = valid_cards[j], valid_cards[i]
        end
        local maxCards = #G.playing_cards > 5 and 5 or #G.playing_cards - 1
        for i = 1, maxCards do
          copy_card(selected_card, G.playing_cards[valid_cards[i]])
        end
      end
    end
  end
}

SMODS.Joker {
  key = "geardice",
  rarity = 3,
  atlas = "temp",
  cost = 8,
  config = {extra = {xmult = 1, xmult_mod = 0.25, hand_type = "High Card"}},
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_mod, card.ability.extra.hand_type}}
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      if context.scoring_name == card.ability.extra.hand_type then
        card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
        card_eval_status_text(card, "extra",nil,nil,nil,
        { message = localize{type = "variable", key = "a_xmult", vars = {card.ability.extra.xmult}}})
      else
        if card.ability.extra.xmult ~= 1 then card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_mod end
        card_eval_status_text(card, "extra", nil, nil, nil,
        { message = localize{type = "variable", key = "a_xmult", vars = {card.ability.extra.xmult}}})
      end
      card.ability.extra.hand_type = context.scoring_name
    elseif context.joker_main then
      return {
        message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult }},
        Xmult_mod = card.ability.extra.xmult,
        card = context.blueprint_card or card
      }
    end
  end
}
