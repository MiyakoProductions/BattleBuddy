; The following offsets in memory may need to be changed after a client update.
; To update the program, simply change these values here. Everything below will
; not need to be changed.
Global $PlayerPointer = 0x172B0F4 ; Static Pointer

; Struct Offsets
Global $PlayerBaseOFS1 = 0x2c0 ; Pointer Offset 0
Global $PlayerBaseOFS2 = 0x1c4 ; Pointer Offset 1
Global $PlayerBaseOFS3 = 0x40  ; Pointer Offset 2
Global $PlayerBaseOFS4 = 0x10  ; Pointer Offset 3
; Offsets in Struct
Global $OFS_LEVEL       = 0x8   ; Player Level
Global $OFS_HEALTH1     = 0x48  ; Health Value
Global $OFS_HEALTH2     = 0x58  ; Max Health
Global $OFS_EHEALTH     = 0x68  ; Extra HP from stamina
Global $OFS_MANA1       = 0x78  ; MP Value
Global $OFS_MANA2       = 0x88  ; Max MP
Global $OFS_EMANA       = 0x98  ; Extra MP from stamina
Global $OFS_PWRFACTOR   = 0x108 ; Power Factor
Global $OFS_ENDFACTOR   = 0x118 ; Endurance Factor
Global $OFS_IMPFACTOR   = 0x128 ; Impact Factor
Global $OFS_BALFACTOR   = 0x138 ; Balance Factor
Global $OFS_MOVESPEED1  = 0x148 ; NonCombat Move Speed
Global $OFS_MOVESPEED2  = 0x168 ; Combat Speed
Global $OFS_CRITRATE    = 0x178 ; Critical Chance
Global $OFS_CRITRESIST  = 0x188 ; Critical Resistance
Global $OFS_CRITPOWER   = 0x198 ; Crit Damage Multiplier
Global $OFS_ATK1        = 0x1a8 ; Attack Value 1
Global $OFS_ATK2        = 0x1b8 ; Attack Value 2
Global $OFS_DEF1        = 0x1c8 ; Defense Value
Global $OFS_IMP         = 0x1d8 ; Impact Value
Global $OFS_BAL         = 0x1e8 ; Balance Value
Global $OFS_RESIST1     = 0x1f8 ; Resistance of Weakening Value, FLOAT
Global $OFS_RESIST2     = 0x208 ; Resistance of Periodic Value, FLOAT
Global $OFS_RESIST3     = 0x218 ; Resistance of Stun Value, FLOAT
Global $OFS_GATHER1     = 0x228 ; Mining Value
Global $OFS_GATHER2     = 0x248 ; Plant Gathering Value
Global $OFS_GATHER3     = 0x258 ; Energy Gathering Value
Global $OFS_POWER       = 0x278 ; Extra Power. 1 power = 0.6% attack. Ex. 16 power = 9.6%. Divide by 100 to get 0.096. Then total attack is: Attack + (Attack * 0.096)
Global $OFS_ENDURANCE   = 0x288 ; Extra Endurance
Global $OFS_MOVESPEED3  = 0x2b8 ; Extra NonCombat Move Speed
Global $OFS_MOVESPEED4  = 0x2d8 ; Extra Combat Speed
Global $OFS_ECRITRATE   = 0x2e8 ; Extra Critical Chance, FLOAT
Global $OFS_ECRITRESIST = 0x2f8 ; Extra Chance to resist crit, FLOAT
Global $OFS_ECRITPOWER  = 0x308 ; Extra Crit Power
Global $OFS_ATK3        = 0x318 ; Attack gained from power. Simplifies our math, Total Atk = OFS_ATK1 + OFS_ATK3
Global $OFS_ATK4        = 0x328 ; Matches OFS_ATK3
Global $OFS_DEF2        = 0x338 ; Extra Defense from Endurance. Total Def = OFS_DEF1 + OFS_DEF2
Global $OFS_ERESIST1    = 0x368 ; Extra Weakening Resistance, FLOAT
Global $OFS_ERESIST2    = 0x378 ; Extra Periodic Resistance, FLOAT
Global $OFS_ERESIST3    = 0x388 ; Extra Stun Resistance, FLOAT
Global $OFS_EGATHER1    = 0x398 ; Extra Mining
Global $OFS_EGATHER2    = 0x3a8 ; Extra Plant Gathering
Global $OFS_EGATHER3    = 0x3b8 ; Extra Energy Gathering
Global $OFS_UNKNOWN1    = 0x3c8 ; Unknown Stat, returned 5
; End of Editable Variables