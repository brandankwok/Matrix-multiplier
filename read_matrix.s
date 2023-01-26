.globl read_matrix


.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
# Returns:
#   a0 is the pointer to the matrix in memory
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# ==============================================================================
read_matrix:
    # prologue
    addi sp, sp, -28 
    sw ra, 0(sp)
    sw s2, 4(sp)
    sw s3, 8(sp)
    sw s4, 12(sp)
    sw s5, 16(sp)
    sw s6, 20(sp)
    sw s7, 24(sp)

    # check file path
    mv a1, a0
    # jal print_str
    # set a2 to 0; fopen will see it as 'read' 
    li a2,0
    jal fopen # a0 file desc, a1 filepath, a2 read permissions
    mv s2, a0 # a0 file descriptor
    mv a1, a0
    # check if file stream has errors
    jal ferror
    bne a0, zero, eof_or_error

    # malloc row pointer
    li a0, 4
    jal malloc # input: a0 = # bytes to allocate  output: a0 = pointer to the allocated heap memory
    mv s3, a0 

    # Malloc col pointer
    li a0, 4
    jal malloc
    mv s4, a0 

    # Read number of rows
    mv a1, s2    
    mv a2, s3 
    li a3, 4
    jal fread # a1 file desc, a2 pointer to buffer you want to write the read bytes to, a3 number of bytes to read

    # Read number of cols
    mv a1, s2
    mv a2, s4
    li a3, 4
    jal fread # a1 file desc, a2 pointer to buffer you want to write the read bytes to, a3 number of bytes to read

    # Calculate bytes
    lw s5, 0(s3)
    lw s6, 0(s4)
    mul s5, s5, s6
    slli s5, s5, 2

    # Allocate space for matrix and read it.
    mv a0, s5
    jal malloc
    # a0 now has pointer.
    mv s7, a0 
    mv a1, s2 # file descriptor
    mv a2, s7 # pointer
    mv a3, s5 # number of bytes
    jal fread
    mv a0, s7

    # Return value
    mv a0, s7 # Pointer with number of elements in vector
    mv a1, s3 # Pointer to rows
    mv a2, s4 # Pointer to cols

    # Epilogue
    lw ra, 0(sp)
    lw s2, 4(sp)
    lw s3, 8(sp)
    lw s4, 12(sp)
    lw s5, 16(sp)
    lw s6, 20(sp)
    lw s7, 24(sp)
    addi sp, sp, 28
    
    ret

eof_or_error:
    li a1 1
    jal exit2
