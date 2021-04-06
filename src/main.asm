.sdsctag 1.10, "smslib Hello World","smslib Hello World example based on Maxim's tutorial","lajohnston"
.incdir "lib/smslib"
.include "smslib.asm"
.incdir "."

.asciitable
  map " " to "~" = 0
.enda

.incdir "assets"
.section "assets" free
  paletteData:
    palette.rgb 0, 0, 0
    palette.rgb 255, 255, 255

  fontData:
    .incbin "../assets/font.bin" fsize fontDataSize

  message:
    .asc "Hello, world!"
    .db $ff
.ends
.incdir "."

.section "init" free
init:
  palette.setSlot 0
  palette.loadSlice paletteData, 2

  patterns.setSlot 0
  patterns.load fontData, fontDataSize

  tilemap.setSlot 0, 0
  tilemap.loadBytesUntil $ff message

  vdp.enableDisplay

  -: jr -
.ends
