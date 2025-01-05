return {
    descriptions = {
        Joker = {
            j_rjd_ragedice = {
                name = 'Rage Dice',
                text = {
                   "each card give {X:mult,C:white} x #1# {} mult when card scored",
                   "{C:green} #3# in #4# {} chance to gain {X:mult,C:white} x #2# {}",
                   "and {C:red}decrease{} chance by {X:green,C:white} #5# {}",
                   "Reset at the end of round",
                }
            },
            j_rjd_bountydice = {
                name = "Bounty Dice",
                text = {
                    "When first hand is played, put a {C:attention}bounty",
                    "on a {C:red}random card{} in hand",
                    "When the card with a {C:attention}bounty{} is played,",
                    "gives {C:red}+#1#{} Mult and {C:money}$#2#",
                    "{s:0.7,C:inactive}Code by AmazinDooD"
                }
            },
            j_rjd_solardice = {
                name = 'Solar Dice',
                text = {
                    'Played {C:attention}3s, 5s, 7s, or 9s{}',
                    'give {C:mult}+Mult{} corresponding with their {C:attention}rank{}',
                    "{s:0.7,C:inactive}Code by Valajar"
                }
            },
            j_rjd_slingshotdice = {
                name = 'Slingshot Dice',
                text = {
                    'Played {C:attention}Aces, 2s, 3s, 4s, or 5s{}',
                    'give {X:mult,C:white}X#1#{} Mult when scored',
                    "{s:0.7,C:inactive}Code by Valajar"
                }
            },
            j_rjd_poisondice = {
                name = 'Poison Dice',
                text = {
                    'After every hand, reduce blind size by {C:attention}3%{}',
                    "{s:0.7,C:inactive}Code by Valajar"
                }
            },
            j_rjd_mimicdice = {
                name = 'Mimic Dice',
                text = {
                    '{C:attention}Retriggers{} Wild Cards {C:attention}#1#{} times',
                    "{s:0.7,C:inactive}Code by Valajar{}"
                }
            },
            j_rjd_brokendice = {
                name = "Broken Dice",
                text = {
                    "A {C:attention}random card{} in played hand",
                    "gains {C:blue}+#1#{} chips",
                    "{s:0.7,C:inactive}Code by AmazinDooD"
                }
            },
            j_rjd_summoningdice = {
                name = "Summoning Dice",
                text = {
                    "Upon discarding {C:red}#1#{C:inactive} (#2#) {}cards,",
                    "{C:attention}create a card{} with an enhancement and",
                    "{C:green}add it to your hand",
                    "{s:0.7,C:inactive}Code by AmazinDooD"
                }
            },
            j_rjd_stardice = {
                name = "Star Dice",
                text = {
                    "Every {C:blue}hand{}, two random",
                    "jokers are {C:attention}retriggered",
                    "{s:0.7,C:inactive}Code by AmazinDooD"
                }
            },
            j_rjd_combodice = {
                name = "Combo Dice",
                text = {
                    "After playing {C:attention}any hand twice in a row",
                    "{C:green}level up{} that hand one time",
                    "{C:inactive}Currently: #1#, #2#/2",
                    "{s:0.7,C:inactive}Code by AmazinDooD"
                }
            },
            j_rjd_holysworddice = {
                name = "Holy Sword Dice",
                text = {
                    "After every hand, {C:green}#3# in #1#{} chance to lower",
                    "blind size by {C:attention}#2#%",
                    "{s:0.7,C:inactive}Code by AmazinDooD and Valajar"
                }
            },
            j_rjd_winddice = {
                name = "Wind Dice",
                text = {
                    "Every other {C:green}Dice{} gives {C:red}+#1#{} Mult",
                    "{s:0.7,C:inactive}Code by AmazinDooD"
                }
            },
            j_rjd_mutationdice = {
                name = 'Mutation Dice',
                text = {
                    'Select {C:attention}one{} card and sell this joker',
                    'transform 15 other random cards into it',
                    "{s:0.7,C:inactive}Code by Valajar and Narrik Synthfox"
                }
            },
            j_rjd_geardice = {
                name = "Gear Dice",
                text = {
                    "{C:white,X:red}X#1#{} Mult",
                    "If hand type is the same as the last hand played, increases by {C:white,X:red}X#2#",
                    "Otherwise, descreases by {C:white,X:red}X#2#",
                    "{C:inactive}(Last hand was a #3#)",
                    "{s:0.7,C:inactive}Code by AmazinDooD"
                }
            },
        },
        Enhanced = {
            m_rjd_bounty = {
                name = "Bounty Card",
                text = {
                    "{C:green}Bounty Dice",
                    "has put a {C:attention}bounty",
                    "on this card"
                }
            }
        },
        Other = {
            dice_def = {
                name = "Dice",
                text = {
                    "All {C:attention}jokers{} from this mod",
                    "are counted as {C:green}Dice"
                }
            }
        }
    }
}
