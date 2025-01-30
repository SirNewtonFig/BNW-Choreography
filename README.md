# BNW Choreography patch

by Sir Newton Fig

sirnewtonfig@gmail.com

## Contents

1) Description
2) Files
3) Technical Bits

## 1) Description

This patch restructures the Dance command in an effort to give the player more control over their actions while Dancing.
* Dances now have Common and Uncommon steps, with probabilities of 2/3 and 1/3, respectively
* The Common step that is available to you will depend on whether you're dancing a new background (Shifting) or dancing the current background (Repeating)
* The Uncommon step is the same whether you are Shifting or Repeating
* The rare Animal abilities may still occur at a 1/16 chance in place of the Common/Uncommon, as a sort of "crit" Dance

Due to the fluid nature of this system, the following core Dance mechanics have also changed:
* Dance status is no longer persistent under any circumstances
* Instead, the Moogle Charm removes stumble rates entirely (otherwise dicated by Stamina)

The overall goal is to replace unpredictability with effort and planning. The Common step being 2/3 likely to occur gives you very good odds you will get an outcome you desire. By Shifting dances from round to round, you can create routines of desired effects instead of simply camping out on a single Dance and hoping for the best – though this can still be useful at times, too!

## 2) Files
```
  |- asm/
  |  |- main.asm
  |  |- dance-tables.asm
  |- ips/...
```

Headered and non-headered version of the ips patches are provided, in addition to the original asm source in case you need to tweak or move anything around. Of note is `dance-tables.asm`, where you can slot the various steps into the desired categories.

## 3) Technical Bits

* This hack claims a portion of the Control effect handler at $C23AC5, currently unused in BNW.
* This hack could be adapted to work in vanilla FF6, but the `JSR $3AB3` in `StumbleCheck` would need to be replaced with a `JSR $4B53`. A piece of equipment with Relic Effect 4:$20 would need to be made available to Mog to leverage the ability to ignore stumble rates, also.
