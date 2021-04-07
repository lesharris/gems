.sdsctag 1.0, "Gems","SMS Remake of the classic game Diamonds","lesharris"

.define mapper.enableCartridgeRam 0
.define interrupts.handleVBlank 1

.incdir "lib/smslib"
.include "mapper/waimanu.asm"
.include "smslib.asm"

.incdir "lib/psglib/src"
.include "PSGlib.inc"

.incdir "."

.include "src/bubble.asm"

.ramsection "bubble" slot mapper.RAM_SLOT
    bubbleInstance: instanceof Bubble
.ends

.slot mapper.PAGE_SLOT_A
.asciitable
  map " " to "~" = 0
.enda

.section "assets" superfree
  paletteData:
    palette.rgb 0, 0, 0
    palette.rgb 255, 255, 255

  fontData:
    .incbin "assets/font.bin" fsize fontDataSize

  message:
    .asc "Hello, world!"
    .db $ff
.ends

.section "harrier" superfree
  harrier:
    .incbin "assets/harrier.psg"
.ends

.section "bridgezone" superfree
  bridgezone:
    .incbin "assets/bridgezone.psg"
.ends

.slot mapper.FIXED_SLOT

.section "init" free
init:
  call PSGInit

  palette.setSlot 0
  palette.loadSlice paletteData, 2

  patterns.setSlot 0
  patterns.load fontData, fontDataSize

  tilemap.setSlot 0, 0
  mapper.pageBank :message
  tilemap.loadBytesUntil $ff message

  palette.setSlot palette.SPRITE_PALETTE
  palette.load bubble.palette, bubble.paletteSize

  patterns.setSlot 256
  patterns.load bubble.patterns, bubble.patternsSize

  ld ix, bubbleInstance
  bubble.init

  vdp.startBatch
    vdp.enableDisplay
    vdp.enableVBlank
    vdp.hideLeftColumn
  vdp.endBatch

  interrupts.enable

  ld hl, :bridgezone
  call PSGPlay

  jp mainLoop
.ends

.section "mainLoop" free
mainLoop:
  interrupts.waitForVBlank

  ld ix, bubbleInstance
  call bubble.updateInput
  call bubble.updateMovement

  sprites.reset
  call bubble.updateSprite

  jp mainLoop
.ends

.section "vBlankHandler" free
  interrupts.onVBlank:
    call PSGFrame
    sprites.copyToVram
    interrupts.endVBlank
.ends
