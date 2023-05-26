C:\Users\%username%\AppData\Local\bin\NASM\nasm -fwin32 main.asm &&^
link /machine:x86 /entry:StartProgram /SUBSYSTEM:CONSOLE kernel32.lib gdi32.lib user32.lib main.obj /out:game.exe