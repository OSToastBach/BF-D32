@echo off

echo Assembling...
asm6809.exe -D main.asm -o BF.BIN -l listing.txt
if errorlevel 1 goto end
echo Creating tape file...
perl ../tools/bin2cas.pl -r 22050 -o bf.wav -D BF.BIN
echo Booting Emulator...
xroar.exe -vo sdl -default-machine dragon32 -extbas D:\CODEDEV\Dragon-32\xroar-0.36.2-w64\D32.rom -nodos -kbd-translate -run BF.BIN -gdb
:end