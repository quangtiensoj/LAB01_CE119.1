
.data
	# Cao ?? 
    	pitch_array: .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
    
    	# ?? dài 
    	duration_array: .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4
    
    	# S? l??ng n?t nh?c
    	num_notes: .word 15
    
    	# Tham s? c?u hình cá nhân
    	instrument: .word 40   # Lo?i nh?c c?
    	volume:     .word 110  # Âm l??ng 
    	tempo_base: .word 210  # 1 ??n v? nh?p = 210 (ms) 

	# Chu?i thông báo in ra màn hình
    	msg_space:      .asciiz " "
    	msg_newline:    .asciiz "\n"
    	msg_tong_dk:    .asciiz "Tong du kien (ms): "
    	msg_thoi_gian:  .asciiz "\nThoi gian do duoc (ms): "

.text
main:
    	# L?y th?i gian h? th?ng b?t ??u l?u vào $s6
    	li $v0, 30
    	syscall
    	move $s6, $a0          

    	# Kh?i t?o các thanh ghi c? s? và bi?n ??m
    	la $s0, pitch_array    # $s0 = ??a ch? m?ng cao ??
    	la $s1, duration_array # $s1 = ??a ch? m?ng ?? dài
    	lw $s2, num_notes      # $s2 = S? n?t (15)
    	lw $s3, instrument     # $s3 = Nh?c c? (40)
    	lw $s4, volume         # $s4 = Âm l??ng (100)
    	lw $s5, tempo_base     # $s5 = 210 ms
    
    	li $t0, 0              # $t0 = Ch? s? vòng l?p i = 0
    	li $s7, 0              # $s7 = T?ng th?i l??ng d? ki?n c?ng d?n (ms)

play_loop:
    	beq $t0, $s2, end_play 
    
    	sll $t1, $t0, 2	    #offset: i * 4

    	add $t2, $s0, $t1
    	lw $t5, 0($t2)         # $t5 = Cao ?? 

    	add $t3, $s1, $t1
    	lw $t4, 0($t3)         # $t4 = ?? dài (nh?p)
    	mul $t6, $t4, $s5      # $t6 =  ?? dài (ms)
    
    	# C?ng d?n vào T?ng d? ki?n
    	add $s7, $s7, $t6
    
    	li $v0, 1
    	move $a0, $t5
    	syscall                # In cao ??

    	li $v0, 4
    	la $a0, msg_space
    	syscall                # In kho?ng tr?ng

    	li $v0, 1
    	move $a0, $t6
    	syscall                # In th?i l??ng ms

    	li $v0, 4
    	la $a0, msg_newline
    	syscall                # In xu?ng dòng


    	# N?p tham s? cho Syscall MIDI:
    	move $a0, $t5          
    	move $a1, $t6          
    	move $a2, $s3          
    	move $a3, $s4          

     	li $v0, 31
     	syscall
     	li $v0, 32
     	move $a0, $t6        
     	syscall


    	# C?U HÌNH B: Syscall 31 
    	# li $v0, 31
    	# syscall
    	# C?U HÌNH A: Syscall 33 
    	# li $v0, 33
    	# syscall
 

    	addi $t0, $t0, 1       # i++
    	j play_loop            # Tái l?p vòng l?p

end_play:
    	# L?y th?i gian h? th?ng k?t thúc (ms)
    	li $v0, 30
    	syscall
    	move $t7, $a0          

    	# Tính Th?i gian ?o ???c 
    	sub $t8, $t7, $s6  

    	# In "Tong du kien (ms): <so>"
    	li $v0, 4
    	la $a0, msg_tong_dk
    	syscall

    	li $v0, 1
    	move $a0, $s7
    	syscall

    	# In "Thoi gian do duoc (ms): <so>"
    	li $v0, 4
    	la $a0, msg_thoi_gian
    	syscall

    	li $v0, 1
    	move $a0, $t8
    	syscall

    	# EXIT
    	li $v0, 10
    	syscall