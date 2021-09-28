# BNW Choreography patch

by Sir Newton Fig

sirnewtonfig@gmail.com

## Contents

1) Description
2) Files
3) Technical Bits

## 1) Description

This patch restructures the Dance command, breaking each biome's list of steps up into two categories: transition steps and sustain steps.
* Transition steps are those that can be chosen from when you dance a new background
* Sustain steps are those that can be chosen when you choose a dance that matches the current background

There are 2 steps in each category, with probabilities as follows:
* Transition steps: 75%/25%
* Sustain steps: 60%/40%

Due to the fluid nature of this system, the following core Dance mechanics have also changed:
* Dance status is no longer persistent under any circumstances
* Instead, the Moogle Charm removes stumble rates entirely (otherwise dicated by Stamina)

The intended purpose of this patch is to replace unpredictability with effort and planning. Any time you select a Dance, there will only be 2 possible outcomes, one of which is more likely than the other to occur. By mixing up dances from round to round, you can create routines of desired effects instead of simply camping out on a single Dance and hoping for the best – though this can still be useful at times, too.

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
