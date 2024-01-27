hirom

!freeC2 = $C23AC5   ; Former home of the Control effect handler, ripe for the picking
!freeE6 = $E68740   ; Freespace at end of "Pointers to Map Names" (E68400-E6877F)

org $C24B5A
  GetRandom:        ; Random Number Generator 2 (0 to 255)

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
  JSR $4B5A         ; A = 0..255 (unchanged from vanilla, included for context)
  JSL StepHelper    ; Sets $EE to the index of the desired Dance step
  LDX $EE
  LDA $CFFE80,X     ; Get attack # for the Dance step used
  PLX
  RTS

padbyte $FF
pad $C205D1          ; 7 bytes reclaimed!

org !freeE6
StepHelper:          ; Select step based on RNG value
  CMP #$60
  BCS .common        ; ..do common   if >= #$60 (10/16)
  CMP #$10
  BCS .uncommon      ; ..do uncommon if >= #$10 (5/16)
.rare
  LDA #$03           ; ..do rare     if < #$10 (1/16)
  BRA .end
.uncommon
  LDA #$02
  BRA .end
.common              ; Select which common step to use based on background
  JSR BGHelper       ; ..C = 1 if background matches chosen Dance
  TDC                ; ..A = 0
  ADC #$00           ; ..A = 0 if shifting, 1 if repeating
.end
  CLC
  ADC $EE            ; Add step index to Dance table pointer
  STA $EE            ; Store it
  RTL

BGHelper:
  LDA $3A6F          ; Load selected Dance
  LDX $11E2          ; Load current background
  CMP $ED8E5B,X      ; Check if Dance for current BG matches selected Dance
  BEQ .repeat        ;
  CLC                ; ..clear carry  if shifting
  RTS                ;
.repeat              ;
  SEC                ; ..set carry if repeating
  RTS


org !freeC2
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

org $CFFE80 ; Reorganize Dance Step -> Attack Number table

; Wind Song
db $66 ; Sun Bath   ; Shift
db $65 ; Wind Slash ; Repeat
db $67 ; Razor Leaf ; Uncommon
db $75 ; Cockatrice ; Rare

; Forest Suite
db $67 ; Razor Leaf ; Shift
db $68 ; Harvester  ; Repeat
db $6B ; Elf Fire   ; Uncommon
db $7A ; Raccoon    ; Rare

; Desert Aria
db $6E ; Mirage     ; Shift
db $66 ; Sun Bath   ; Repeat
db $69 ; Sand Storm ; Uncommon
db $77 ; Meerkat    ; Rare

; Love Sonata
db $6B ; Elf Fire   ; Shift
db $6C ; Bedevil    ; Repeat
db $6A ; Moonlight  ; Uncommon
db $78 ; Tapir      ; Rare

; Earth Blues
db $ED ; Landslide  ; Shift
db $6D ; Avalanche  ; Repeat
db $66 ; Sun Bath   ; Uncommon
db $79 ; Wild Boars ; Rare

; Water Rondo
db $6F ; El Nino    ; Shift
db $70 ; Plasma     ; Repeat
db $74 ; Surge      ; Uncommon
db $7B ; Toxic Frog ; Rare

; Dusk Requiem
db $6A ; Moonlight  ; Shift
db $71 ; Snare      ; Repeat
db $72 ; Cave In    ; Uncommon
db $76 ; Wombat     ; Rare

; Snowman Jazz
db $73 ; Blizzard   ; Shift
db $74 ; Surge      ; Repeat
db $6E ; Mirage     ; Uncommon
db $7C ; Ice Rabbit ; Rare

