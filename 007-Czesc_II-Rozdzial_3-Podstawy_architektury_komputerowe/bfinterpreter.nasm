%include "vm.inc"

vset r0, 0 ; zero
vset r1, 1 ; one
vset r2, 0 ; acc
vmov r3, tape; data pointer
vset r4, program_data ; program end
vset r5, program_data ; program pointer

read_data:
  vinb 0x21, r2  ; load console (stdin) state
  vcmp r2, r0 ; any data on stdin?
  vjz run ; if not jump to run

  vinb 0x20, r2 ; get program byte
  vstb r4, r2 ; write program byte to memory
  vadd r4, r1 ; increment program pointer

  vjmp read_data

run:
  vcmp  r5, r4; check if last program byte
  vjz end ; end program if last byte

  vldb r2, r5; load program byte
  voutb 0x20, r2 ; print byte <--step handling here
  vadd r5, r1 ; increment program pointer

  vjmp run_step

run_step:
  vjmp run

end:
  voff ; power off

tape:
  times 30000 db 0 ; tape

program_data:
