.globl gemv

.text
# =======================================================
# FUNCTION: Matrix Vector Multiplication
# 	d = gemv(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of v
# 	a4 is the # of rows (height) of v
#	a5 is the pointer to the the start of d
# Returns:
#	None, sets d = gemv(m0, m1)
# =======================================================
gemv:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions
    
    # Prologue
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)

    # saving arguments
    mv s0, a0 # pointer to start of m0
    mv s1, a1 # height of m0
    mv s2, a2 # width of m0
    mv s3, a3 # pointer to start of m1 
    mv s4, a4 # height of m1
    mv s5, a5 # pointer to start of d

    # set stride 
    li s6, 4
    mul s6, s6, s2

    # set loop index
    add s7, x0, x0

outer_loop_start_gemv:

    beq s7, s1, outer_loop_end_gemv
    # moving saved arguments to corresponding dot.s registers 
    mv a0, s0
    mv a1, s3
    mv a2, s2
    li a3, 1
    li a4, 1
    # calling dot function; returns number in a0
    jal dot
    # store the result into each index of d and increment
    sw a0, 0(a5)
    addi a5, a5, 4
    # increment matrix to next row
    add s0, s0, s6
    addi s7, s7, 1
    j outer_loop_start_gemv


#Epilogue
outer_loop_end_gemv:
    mv a5, s5

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    addi sp, sp, 36

    ret

mismatched_dimensions:
    li a1 2
    jal exit2