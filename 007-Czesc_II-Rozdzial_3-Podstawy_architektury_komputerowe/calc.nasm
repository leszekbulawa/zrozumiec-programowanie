%include "vm.inc"

vset r1, 0 ; zero
vset r2, 1 ; one
vxor r4, r4 ; first number
vxor r5, r5 ; second number
vset r6, 10 ; multiplier
vxor r7, r7 ; buffer
vset r8, 48  ; ascii offset
vset r9, 10 ; LF ascii
vxor r10, r10 ; counter

loop1:
  vinb 0x20, r0  ; Any data on STDIN?
  vcmp r0, r9 ; check if newline
  vjz loop2 ; if newline go to loop2
  
  vmul r4, r6 ; multiply by 10
  vsub r0, r8 ; subtract ascii offset

  vadd r4, r0 ; store value
  vinb 0x21, r0  ; Any data on STDIN?
  vcmp r0, r1
  vjz loop2  ; Nope, go away.

  vjmp loop1

loop2:
  vinb 0x20, r0  ; Any data on STDIN?
  vcmp r0, r9 ; check if newline
  vjz addition ; if newline go to addition
  
  vmul r5, r6 ; multiply by 10
  vsub r0, r8 ; subtract ascii offset

  vadd r5, r0 ; store value
  vinb 0x21, r0  ; Any data on STDIN?
  vcmp r0, r1
  vjz addition  ; Nope, go away.

  vjmp loop2

addition:
  vadd r5, r4 ; add two numbers
  vjmp print  

print:
  vmov r7, r5 ; copy value to buffer
  vmod r7, r6 ; modulo div buffer by 10
  vadd r7, r8 ; add ascii offset
  vpush r7 ; push to stack
  vadd r10, r2 ; increment counter

  vdiv r5, r6 ; divide original number by 10 without rest

  vcmp r5, r1 ; check if end of division
  vjz output 

  vjmp print

output: ; reverse output
  vpop r0 ; pop from stack
  voutb 0x20, r0 ; spit one byte  
  vsub r10, r2 ; decrement coutner
  vcmp r10, r1 ; check if counter is zero
  vjz end ; exit if counter is zero
  
  vjmp output

end:
  voff