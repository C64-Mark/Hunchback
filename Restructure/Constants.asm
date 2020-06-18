;-------------------------------------------------------------------------------
; COLOUR CONSTANTS
;-------------------------------------------------------------------------------
BLACK                           = 0
WHITE                           = 1
RED                             = 2
CYAN                            = 3
PURPLE                          = 4
GREEN                           = 5
BLUE                            = 6
YELLOW                          = 7
BROWN                           = 9
LIGHTRED                        = 10
GRAY1                           = 11
GRAY2                           = 12
LIGHTBLUE                       = 14
GRAY3                           = 15


;-------------------------------------------------------------------------------
; CHAR CONSTANTS
;-------------------------------------------------------------------------------
CHAR_SPACE                      = 32
CHAR_1                          = 49
CHAR_WALL3DTOP                  = 59
CHAR_WALL3D                     = 60
CHAR_LIVESMARKER                = 61
CHAR_WALL                       = 62
CHAR_BELL_UL                    = 63
CHAR_BELL_UR                    = 64
CHAR_BELL_LL                    = 65
CHAR_BELL_LR                    = 66
CHAR_LEVELMARKER                = 99
CHAR_FIRE                       = 114


;-------------------------------------------------------------------------------
; SOUND CONSTANTS
;-------------------------------------------------------------------------------
SND_DISABLE_VOICE               = 8
SND_TRIANGLE_GATE_OFF           = 16
SND_TRIANGLE_GATE_ON            = 17
SND_SAW_GATE_OFF                = 32
SND_SAW_GATE_ON                 = 33
SND_PULSE_GATE_OFF              = 64
SND_PULSE_GATE_ON               = 65
SND_NOISE_GATE_OFF              = 128
SND_NOISE_GATE_ON               = 129
SND_LOW_PASS_FILTER_MASK_ON     = %00010000


;-------------------------------------------------------------------------------
; INPUT CONSTANTS
;-------------------------------------------------------------------------------
KEY_F1                          = 4
KEY_SPACE                       = 60
KEY_NONE                        = 64
KEY_J                           = 74
KEY_K                           = 75
JOY_LEFT                        = 4
JOY_RIGHT                       = 8
JOY_FIRE                        = 16


;-------------------------------------------------------------------------------
; SPRITE FRAME CONSTANTS
;-------------------------------------------------------------------------------
SPRITE_HEART_FRAME1             = 58
SPRITE_KNIGHT_CLIMB_FRAME1      = 63
SPRITE_QUASI_WALK_RIGHT_FRAME2  = 67
SPRITE_QUASI_SWING_RIGHT_FRAME  = 73
SPRITE_ARROW_RIGHT_FRAME        = 74
SPRITE_ARROW_LEFT_FRAME         = 75
SPRITE_FIREBALL_FRAME1          = 76
SPRITE_QUASI_SWING_LEFT_FRAME   = 87


;-------------------------------------------------------------------------------
; SPRITE MASKS
;-------------------------------------------------------------------------------
SPRITE0_MASK_ON                 = %00000001
SPRITE0_MASK_OFF                = %11111110
SPRITE1_MASK_ON                 = %00000010
SPRITE1_MASK_OFF                = %11111101
SPRITE2_MASK_ON                 = %00000100
SPRITE2_MASK_OFF                = %11111011
SPRITE3_MASK_ON                 = %00001000
SPRITE3_MASK_OFF                = %11110111
SPRITE4_MASK_ON                 = %00010000
SPRITE6_MASK_ON                 = %01000000
SPRITE7_MASK_ON                 = %10000000


;-------------------------------------------------------------------------------
; GENERAL CONSTANTS
;-------------------------------------------------------------------------------
QUASI_DIR_RIGHT                 = 0
QUASI_DIR_LEFT                  = 1
FALSE                           = 0
TRUE                            = 1
ROPE_SPEED                      = 6
MISSILE_LOW_Y                   = 117
MISSILE_HIGH_Y                  = 88
QUASI_MOVE_RATE                 = 2
HEART_ANIM_RATE                 = 64
ROPE_UPPER_Y                    = 66
ROPE_LOWER_Y                    = 108


;-------------------------------------------------------------------------------
; OBSTACLE CONSTANTS
;-------------------------------------------------------------------------------
OBSTACLE_ROPE                   = 1
OBSTACLE_FIREBALL_HI_FRONT      = 2
OBSTACLE_ARROW_LO_REAR          = 4
OBSTACLE_FIREBALL_LO_FRONT      = 8
OBSTACLE_DUO_ARROW_HILO_FRONT   = 16
OBSTACLE_DUO_ARROW_HILO_REAR    = 32
OBSTACLE_DUO_FIREBALL_LO_BOTH   = 64
OBSTACLE_DUO_ARROW_HILO_BOTH    = 128


;-------------------------------------------------------------------------------
; LEVEL TYPES
;-------------------------------------------------------------------------------
LEVEL_KNIGHTPIT                 = 1
LEVEL_EMPTYPIT                  = 2
LEVEL_ROWOFBELLS                = 4
LEVEL_ROPEPIT                   = 8

