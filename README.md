# Dragon 32 Brainfuck Interpreter

Bored of BASIC? No problem!

## Usage

Due to the Dragon's lack of `[` and `]` characters, which are quite important in brainfuck, the inputs have been swapped with `(` and `)`.
As for some reason square brackets are in the character set but there are no keys for it on the keyboard!

As the Dragon does not use a standard character set, the values for characters are slightly different. An image of all the available characters for reference can be seen [here](https://www.chibiakumas.com/6809/res/DragonChars.png) and on page 136 of [An introduction to BASIC programming using the DRAGON](http://dragondata.co.uk/Publications/BASIC-MAN/DRAGON_32_BASIC_MANUAL_rel-v2.pdf).

Included are a disk image: `BF.VDK`, tape file: `bf.wav` and binary file: `BF.BIN`.

## Compiling

To compile, `asm6809` is needed, optionally `bin2cas` and `dragondos` but these two are not required for building the binary and are just to create the disk and tape images.
