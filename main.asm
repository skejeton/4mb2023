[BITS 32]
%include "graphics.asm"

section .text

global _StartProgram
extern _ExitProcess@4
extern _CreateWindowExA@48
extern _RegisterClassA@4
extern _GetMessageA@16
extern _TranslateMessage@4
extern _DispatchMessageA@4
extern _AdjustWindowRect@12
extern _DefWindowProcA@16
extern _ShowWindow@8

  
; eax = width in/out
; ebx = height in/out
FixWindowRect:
  mov [Gfx_Wrect_Tmp+0*4], dword 0 ;l
  mov [Gfx_Wrect_Tmp+1*4], dword 0 ;t
  mov [Gfx_Wrect_Tmp+2*4], eax     ;r
  mov [Gfx_Wrect_Tmp+3*4], ebx     ;b

  push dword 0 ; menu = false
  push dword 13565952 ; WS_OVERLAPPEDWINDOW
  push Gfx_Wrect_Tmp
  call _AdjustWindowRect@12

  mov eax, dword [Gfx_Wrect_Tmp+2*4]
  sub eax, dword [Gfx_Wrect_Tmp+0*4]
  mov ebx, dword [Gfx_Wrect_Tmp+3*4]
  sub ebx, dword [Gfx_Wrect_Tmp+1*4]
  ret

_StartProgram:

  ; create window class
  push wndclass
  call _RegisterClassA@4
  
  mov eax, GFX_RES_X
  mov ebx, GFX_RES_Y
  call FixWindowRect

  ; create window
  push dword 0
  push dword 0
  push dword 0
  push dword 0
  push dword ebx
  push dword eax
  push dword 0
  push dword 0
  push dword 13565952 ; WS_OVERLAPPEDWINDOW
  push caption
  push windowclassname
  push dword 0
  call _CreateWindowExA@48
  mov [hwnd], eax    
  
  ; show window
  mov eax, [hwnd]
  push dword 1 ; yes, display window pls
  push eax
  call _ShowWindow@8

  call Gfx_Init

.msgloop:
  push dword 0
  push dword 0
  push dword 0
  push msg
  call _GetMessageA@16
  cmp eax, 0
  je .finish
  
  push msg
  call _TranslateMessage@4

  push msg
  call _DispatchMessageA@4
  jmp .msgloop

.finish:
  push 0
  call _ExitProcess@4

section .data
wndclass:
    dd 72
    dd _DefWindowProcA@16
    dd 0
    dd 0 
    dd 0 
    dd 0
    dd 0 
    dd 0
    dd 0
    dd windowclassname
  windowclassname db "GraVVVVVVitron-WindowClass", 0
  caption db "GraVVVVVVitron", 0
  caption_siz dd 14

section .bss
  hwnd resd 1
  msg resd 8
  

  
  Gfx_Wrect_Tmp: resd 4