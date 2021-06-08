    bits    32
    section .text
    global  checkerboard24

checkerboard24:
; prologue
        push    ebp
        mov     ebp, esp
        push    ebx
        push    esi
        push    edi
        mov     eax, [ebp+8]
        mov     edi, eax
        mov     edx, [ebp+16]       ; load the first color
        mov     ebx, [ebp+20]       ; load the second color
        mov     esi, [eax+22]       ; load a height of the image
        xor     ebx, edx            ; calculate a xor mask which changes colors
; Calculate padded width
        mov     eax, [eax+18]
        lea     eax, [eax+eax*2+3]
        and     eax, -4
; Set edi to the image's pointer
        add     edi, 54
; Shift registers to make room for other variables
        shl     eax, 8
        shl     ebx, 8
        add     bl, [ebp+12]        ; load an 8 bit square height counter
new_line:
        mov     ecx, eax            ; load a padded width of the image
        shr     ecx, 8
; Select a proper primary color
        mov     edx, [ebp+16]
        test    al, 1               ; check a primary color flag
        cmovnz  edx, [ebp+20]       ; if the primary color flag is zero set first color to other
        shl     edx, 8
        add     dl, [ebp+12]        ; set an 8 bit square width counter to the sq_size
        dec     bl                  ; decrease square height counter
        ja      set_pixel;change_color        ; if it last row of the square change the primary color
        not     al
        add     bl, dl              ; load an 8 bit square height counter
        add     dl, 1
change_color:
; Change color
        dec     dl
        ja      set_pixel           ; checks if there is end of the square
        xor     dh, bh              ;Set new color in edx
        ror     edx, 16
        ror     ebx, 16
        xor     dx, bx
        rol     edx, 16
        rol     ebx, 16
        add     dl, [ebp+12]        ; Set new width square counter to sq_size
set_pixel:
        sub     ecx, 3              ; decrease width count
        mov     [edi], dh           ; set color of the pixel to
        ror     edx, 16
        mov     [edi+1], dx
        rol     edx, 16
        add     edi, 3

        cmp     ecx, 3              ; check width pointer
        ja      change_color
        add     edi, ecx            ; add Zpadding

        dec     esi
        ja      new_line            ; check height pointer

        mov     eax, [ebp+8]        ; set a pointer to the image as return value
        ; epilogue
        pop     edi
        pop     esi
        pop     ebx
        pop     ebp
        ret