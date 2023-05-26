section .text
; -----------------------------------------------------------------------------
%define GFX_RES_X 640
%define GFX_RES_Y 480
; -----------------------------------------------------------------------------
extern _BeginPaint@8
extern _EndPaint@8
extern _TextOutA@20
extern _CreateDIBSection@24
extern _GetDC@4
; -----------------------------------------------------------------------------
Gfx_Init:
  ; gf_hdc = GetDC(...) 
  push dword 0 ; window_handle=NULL
  call _GetDC@4
  mov [Gfx_HDC], eax ; save DC
  
  ; paintdc = BeginPaint(...)
  push Gfx_PaintStruct ; dest paint struct
  mov eax, [hwnd]
  push eax ; hwnd
  call _BeginPaint@8
  mov [Gfx_PaintDC], eax

  ; TextOut(...)
  mov eax, [Gfx_TestText_Length]
  push eax
  push Gfx_TestText
  push dword 30 ; y
  push dword 30 ; x
  mov eax, [Gfx_PaintDC]
  push eax ; hdc
  call _TextOutA@20

  ; EndPaint(...)
  push Gfx_PaintStruct ; the paintstruct we used
  mov eax, [hwnd]
  push eax ; hwnd
  call _EndPaint@8
  ret
; -----------------------------------------------------------------------------
section .data
Gfx_TestText: db "The quick brown fox jumps over the lazy dog.", 0
Gfx_TestText_Length: dd 44
; -----------------------------------------------------------------------------
section .bss
; type: HDC
Gfx_HDC: resd 1
Gfx_PaintDC: resd 1
Gfx_PaintStruct: resb 64 
