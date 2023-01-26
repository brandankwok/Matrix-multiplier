.import ../read_matrix.s
.import ../gemv.s
.import ../dot.s
.import ../utils.s

.data
output_step1: .asciiz "\n**Step result = gemv(matrix, vector)**\n"



.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <VECTOR_PATH> <MATRIX_PATH> 

    # Exit if incorrect number of command line args
    li s2, 3 # Expect 3 arguments
    mv s3, a0 # (argc = number of arguments)
    blt a0, s2, error # if argc < 3 jump to exit

# =====================================
# LOAD MATRIX and VECTOR. Iterate over argv.

    # RECALL read_matrix returns: 
    #   a0 is the pointer to the matrix in memory
    #   a1 is a pointer to the number of rows
    #   a2 is a pointer to the number of columns

    # argv[1]
    mv s4, a1 # (char** argv). s4 char* argv[] 
    addi s4, s4, 4 # Dereferencing the first string to skip main.s

    lw a0, 0 (s4)   # s4[0]. (pointer to string containing VECTOR's path)
    jal read_matrix 
    # allocate space on stack for storing VECTOR's parameters
    addi sp, sp, -8
    sw a0, 0 (sp) # Base address of read matrix
    sw a1, 4 (sp) # rows


    # argv[2]
    lw a0, 4(s4) # s4[1] (pointer to string containing MATRIX's path)
    jal read_matrix 
    # allocate space on stack for storing MATRIX's parameters
    addi sp, sp, -12
    sw a0, 0 (sp) # Base address of read matrix
    sw a1, 4 (sp) # rows
    sw a2, 8 (sp) # cols

    # -------------
    # Row*
    # VECTOR*
    # Col*
    # Row*             ^ 
    # MATRIX*          | 
    # <-----------SP   |
    
# =====================================
# Load Matrix   
    mv t4, sp
    lw s2, 0 (t4)
    lw s3, 4 (t4)
    lw s5, 8 (t4)
    lw s3, 0 (s3)
    lw s5, 0 (s5)    
# Load Vector
    addi t4, t4, 12
    lw s7, 0 (t4)
    lw s8, 4 (t4)
    lw s8, 0 (s8)
    li s9, 1

# Registers
# s2 - matrix*    s3 - rows  s5 - cols
# s7 - vector*    s8 - rows  s9 - cols (hardcoded to 1)

# Allocate output (matrix:rows s3 * input:cols s5)
    mul s3, s3, s9
    mv t2, s3  # (t2 number of elements)
    slli t2, t2, 2 (# of bytes to allocate)
    mv a0, t2
    jal malloc
    mv s4, a0

# Registers
# s2 - matrix*    s3 - rows  s5 - cols
# s7 - input (vector)* s8 - rows 
# s4 - output*

# =====================================
# RUN GEMV

#   RESULT: d = gemv(m0, m1)
# Arguments:
# 	a0 is the pointer to the start of matrix
#	a1 is the # of rows (height) of matrix
#	a2 is the # of columns (width) of matrix
#	a3 is the pointer to the start of vector
# 	a4 is the # of rows (height) of vector
#	a5 is the pointer to the the start of d
# Returns:
#	None, sets d = gemv(m0, m1)
    mv a0, s2
    mv a1, s3
    mv a2, s5
    mv a3, s7
    mv a4, s8
    mv a5, s4
    jal gemv

# Temporarily save the result
    mv s5, a5

# Print the result
    la a1, output_step1
    jal print_str

    mv a0, s5
    mv a1, s3
    li a2, 1
    jal print_int_array
# =====================================
# SPMV :    m * v

    # la a1, output_step1
    # jal print_str

    ## FILL OUT. Output is a dense vector.
#    mv a0,# Base ptr
#    mv a1,#rows
#    mv a2,#cols
#    jal print_int_array 










    
 




















    # Print newline afterwards for clarity
    # li a1 '\n'
    # jal print_char

    jal exit

error: 
    # la a1, error_msg
    # jal print_str
    li a1, 3
    jal exit2
