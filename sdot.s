.globl sdot

.text
# =======================================================
# FUNCTION: Dot product of 1 sparse vectors and 1 dense vector
# Arguments:
#   a0 is the pointer to the start of v0 (sparse, coo format)
#   a1 is the pointer to the start of v1 (dense)
#   a2 is the number of non-zeros in vector v0
# Returns:
#   a0 is the sparse dot product of v0 and v1
# =======================================================
#
# struct coo {
#   int row;
#   int index;
#   int val;
# };   
# Since these are vectors row = 0 always for v0.
#for (int i = 0 i < nnz; i++) {
#    sum = sum + v0[i].value * v1[coo[i].index];
# }
sdot:
    # Prologue
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp) 
    sw s8, 36(sp) 
    sw s9, 40(sp) 
    sw s10, 44(sp) 
    # Save arguments
    mv s0, a0 # pointing to start of v0 (sparse, coo format)
    mv s1, a1 # pointing to start of v1 (dense)
    mv s2, a2 # number of non-zeroes in vector v0
    # Set strides. Note that v0 is struct. v1 is array.
    li s3, 12
    li s10, 4
    # Set loop index
    li s4, 0
    # Set accumulation to 0
    li s9, 0
    addi s0, s0, 4
    

loop_start:

    # Check outer loop condition
    beq s4, s2, loop_end
    # load v0[i].value. The actual value is located at offset  from start of coo entry
    lw s5, 4(s0)
    # What is the index of the coo element?
    lw s6, 0(s0)
    # # Lookup corresponding index in dense vector
    # # Load v1[coo[i].index]
    mul s6, s6, s10
    add s1, s1, s6
    lw s7, 0(s1)
    sub s1, s1, s6
    # # Multiply and accumulate
    mul s8, s7, s5
    add s9, s9, s8
    # Bump ptr to coo entry
    add s0, s0, s3
    # Increment loop index
    addi s4, s4, 1
    j loop_start

loop_end:
    mv a0, s9

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48

    ret

