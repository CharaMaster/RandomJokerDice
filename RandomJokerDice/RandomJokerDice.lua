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

SMODS.Joker {
  key = 'rage dice',
  loc_txt = {
    name = 'Rage Dice',
    text = {
      "each card give {X:mult,C:white} x #1# {} mult when card scored",
      "gain {X:mult,C:white} x #2# {} mult per card scored",
      "Reset at the end of round",
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

    if context.end_of_round
        and not context.game_over and not
        context.individual and not
        context.repetition and not
        context.retrigger_joker
        and card.ability.extra.xmult > 1 then
      card.ability.extra.xmult = 1
      return {
        message = localize('k_reset'),
        colour = G.C.RED,
        card = card
      }
    end
  end
}
