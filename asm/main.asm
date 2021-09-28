hirom

!free = $C23AC5     ; Former home of the Control effect handler, ripe for the picking

org $C21780
  AND #$FE          ; Always clear Dance status

org $C2179D
  JSR StumbleCheck  ; Let Moogle Charm bypass stumble chance

org $C219ED
  dw $177D          ; Revert Dance code pointer (decouple Moogle Charm from controlled dance)

org $C23C82         ; Reclaim space for Moogle Charm Dance wrapper
  padbyte $FF
  pad $C23C8F

org $C205B6         ; Modify how Dance step is determined
  JSL PickType      ; X = index of Dance step
  JSR $4B65         ; RNG (0..7)
  CMP.l Thresholds,X  ; Compare number with threshold
  BCS +             ; Use the common step if above
  INC $EE           ; Use the uncommon step if below
+ LDX $EE
  LDA $CFFE80,X     ; Get attack # for the Dance step used
  PLX
  RTS

; Data
Thresholds:
  db $05            ; Transition steps: choose A if RNG(0..19) >= 5 (75%), else B
  db $08            ; Sustain steps: choose A if RNG(0..19) >= 8 (60%), else B

padbyte $FF
pad $C205D1         ; 2 bytes reclaimed, wowee

org !free
PickType:
  LDA $3A6F
  LDX $11E2
  CMP $ED8E5B,X     ; Check if background is same as dance
  BNE +             ; Branch if not
  rep 2 : INC $EE   ; Use lower half of step list for sustain steps
  LDX #$01          ; Use sustain probabilities
  BRA ++
+ LDX #$00          ; Use transition probabilities
++ LDA #$14
+ RTL

StumbleCheck:
  PHA
  LDA $3C59,Y       ; Relic Effects 4
  BIT #$20          ; Moogle Charm flag (unused in Vanilla)
  BNE +
  JSR $3AB3         ; Check for stumble rate if no Charm equipped
  BRA ++
+ SEC               ; Proceed without stumble check if Charm equipped
++ PLA
  RTS

padbyte $FF         ; Reclaim (most of) the rest of the routine
pad $C23B1B         ; After this, some of the Control code miss condition is still required

incsrc "dance-tables.asm"