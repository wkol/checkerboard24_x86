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
        mov     edx, [ebp+16]
        mov     ebx, [ebp+20]
        mov     esi, [eax+22]
        xor     ebx, edx
        mov     eax, [eax+18]
        lea     eax, [eax+eax*2+3]
        and     eax, -4
        add     edi, 54
        shl     eax, 8
        shl     ebx, 8
        mov     bl, [ebp+12]
        add     bl, 1
new_line:
;CHANGE IT LATER
        dec      bl                  ;Decrease height square counter
        jnz      set_primary        ; if == 0 set_new_bl
        not      al
        mov      bl, [ebp+12]
set_primary:
        mov     ecx, eax
        shr     ecx, 8
        mov     edx, [ebp+20]
        shl     edx, 8
        mov     dl, [ebp+12]
        and     al, 1
        jnz     change_color         ; if primary color is 1 change
        mov     edx, [ebp+16]
        shl     edx, 8
        mov     dl, [ebp+12]
change_color:
        dec     dl
        jns     set_pixel      ; checks if there is end of the square
        xor     dh, bh              ;Set new color in edx
        ror     edx, 16
        ror     ebx, 16
        xor     dx, bx
        rol     edx, 16
        rol     ebx, 16
        mov     dl, [ebp+12]        ;Set new width square counter to sq_size
set_pixel:
        sub     ecx, 3              ; decrease width count
        ror     edx, 8              ; get color from edx
        mov     [edi], dx           ; set color of the pixel to
        ror     edx, 16
        mov     [edi+2], dl
        rol     edx, 24
        add     edi, 3
        ; Checks
        cmp     ecx, 3
        jge     change_color
        add     edi, ecx
        dec     esi
        jnz     new_line
end:
        mov     eax, [ebp+8]        ; set a pointer to the image as return value
        ; epilogue
        pop     edi
        pop     esi
        pop     ebx
        pop     ebp
        ret