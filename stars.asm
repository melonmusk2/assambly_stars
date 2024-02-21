; Define a global symbol named "_start"
global _start

section .data
  ; Define a variable named "rows" with a word (2 bytes) size and initialize it with 20
  rows dw 20

section .text
_start:

; Read the number of rows from the "rows" variable and store it in ebx
movzx ebx, byte [rows] ; ebx holds number of rows

; Calculate the total number of symbols to print (rows * 4 + 3) and store it in eax
; Add 3 to account for the initial 3 asterisks and the final newline
lea eax, [ebx+3]
imul eax,ebx
shr eax,1 ; now eax holds number of all symbols

; Copy the total number of symbols to edx for later use during printing
mov edx,eax ; now edx holds number of all symbols, used in print

; Prepare a pointer to the beginning of the string by subtracting the total number of symbols from the stack pointer (esp)
mov ecx,esp
sub ecx,eax ; ecx points on the beginning of the string, used in print

; Fill the string with asterisks (*)
mov eax,edx
shr eax,2 ; Divide eax by 4 to get the number of iterations
mov ebp, dword '****' ; Load the value '****' (4 asterisks) into ebp

next_star:
  ; Store the value from ebp (****) at the current memory location pointed to by ecx
  mov [ecx+4*eax],ebp
  ; Decrement the loop counter (eax)
  dec eax
  ; Jump back to "next_star" if there are more asterisks to print (eax >= 0)
  jge next_star

; Fill the string with newline characters (\n) after the asterisks
mov edi,esp
dec edi ; Move edi one position back to point to the end of the string
mov eax,ebx; in the eax is number of rows
inc eax ; Add 1 to eax to include the final newline at the end
next_n:
  ; Store the newline character (0x0a) at the current memory location pointed to by edi
  mov [edi],byte 0xa
  ; Subtract the number of rows from edi to move it to the beginning of the string
  sub edi,eax
  ; Decrement the loop counter (eax)
  dec eax
  ; Jump back to "next_n" if there are more newlines to print (eax > 0)
  jg next_n

; Print the string using system call (sys_write)
; eax = 4 (system call number for write)
; ebx = 1 (file descriptor for stdout)
; ecx = pointer to the string (already in ecx)
; edx = number of bytes to write (total number of symbols)
mov eax,4
mov ebx,1
int 80h

; Exit the program using system call (sys_exit)
; eax = 1 (system call number for exit)
; ebx = 0 (exit code)
mov eax,1
xor ebx,ebx
int 80h

ret
