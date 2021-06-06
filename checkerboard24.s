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
        mov     eax, [ebp+8]     ; EAX contains pointer to the image
        mov     ecx, [eax+18]    ; get width of the image
        mov     edx, [ebp+16]    ; first 24 bits of EDX contains the first color
        mov     ebx, [ebp+20]
        mov     esi, [eax+22]    ; get height
        xor     ebx, edx
        shl     edx, 8
        shl     ebx, 8
        mov     dl, [ebp+12]     ; last 8 bits of EDX contains square_size_width
        mov     bl, dl           ; cl contains square_size_height
        lea     ecx, [ecx+ecx*2+3]
        and     ecx, -4
        mov     edi, eax
        add     edi, 54
        mov     eax, [ebp+16]
        shl     eax, 8
new_row:
        xor     ah, bh
        ror     eax, 16
        ror     ebx, 16
        xor     ax, bx
        rol     eax, 16
        rol     ebx, 16
        ;mov     edx, eax
        mov     bl, [ebp+12]
new_line:
        mov     ecx, [ebp+8]
        mov     ecx, [ecx+18]
        lea     ecx, [ecx+ecx*2+3]
        and     ecx, -4
        mov     edx, eax
        mov     dl, [ebp+12]
        dec     bl                  ;Decrease height square counter
        jz      new_row
change_color:
        xor     dh, bh              ;Set new color in edx
        ror     edx, 16
        ror     ebx, 16
        xor     dx, bx
        rol     edx, 16
        rol     ebx, 16
        mov     dl, [ebp+12]        ;Set new width square counter to sq_size
set_pixel:
        sub     ecx, 3
        ror     edx, 8
        mov     [edi], dx
        ror     edx, 16             ;0x00RRGGBB
        mov     [edi+2], dl
        rol     edx, 24
        add     edi, 3
        dec     dl
        jz      change_color
        cmp     ecx, 3
        jge     set_pixel
        add     edi, ecx
        dec     esi
        jnz     new_line

end:        ; epilogue
        mov     eax, [ebp+8]
        pop     edi
        pop     esi
        pop     ebx
        pop     ebp
        ret