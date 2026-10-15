# $s0       Luu dia chi co so mang A (Muc thap nhat cua 6 bac)
# $s1       Luu dia chi co so mang C (Muc cao nhat cua 6 bac)
# $s2       Luu dia chi co so mang B (don gia cua 6 bac)
# $s3       Luu tong tien dien tinh duoc (
# $s4       Luu gia tri x (kWh)
# $t0       Bien dem chi so vong lap (tu 0 -> 5)
# $t1       Luu gia tri A[i] dang xet
# $t2       Luu gia tri C[i] dang xet
# $t3       Luu gia tri B[i] dang xet
# $t4       Luu so kWh dang tinh cho bac i (kwh_i)
# $v0, $a0  Syscall (Nhap, xu ly, in ket qua)

.data
	arrayA:		.word 1, 51, 101, 201, 301, 401 		# m?ng A: M?c th?p nh?t ? m?i b?c
	arrayB:		.word 1600, 1660, 1950, 2500, 2850, 3000 	# m?ng B: ??n giá ? m?i b?c
	arrayC: 	.word 50, 100, 200, 300, 400, 9999		# m?ng C: M?c cao nh?t ? m?i b?c
	msg_input:	.asciiz "Nhap so kWh (0..9999): "
	msg_error:	.asciiz "Gia tri khong hop le, nhap lai"
	msg_result:	.asciiz "Tien dien: "
	msg_unit:	.asciiz " dong"

.text
main:
#khoi tao
	la $s0, arrayA
	la $s1, arrayC
	la $s2, arrayB
	li $s3, 0

input_loop:
	li $v0, 4
	la $a0, msg_input
	syscall
	
	li $v0, 5
	syscall
	move $s4, $v0		#$s4 = x

#kiem tra x 
    	sltiu  $t8, $s4, 10000      
   	beq   $t8, $zero, input_invalid
   	j start_calc
	
input_invalid:
	li $v0,4
	la $a0, msg_error
	syscall
	j	input_loop

#bat dau chu trinh kiem tra
start_calc:
	li $t0, 0


calc_loop:
    	lw $t1, 0($s0)          # A[i]
    	bgt $t1, $s4, print_result # A[i] > x => Xong

    	lw $t2, 0($s1)          # C[i]
    	lw $t3, 0($s2)          # NB[i]

    	bgt $s4, $t2, calc_full # x > C[i] 

    	sub $t4, $s4, $t1
    	addi $t4, $t4, 1
    	j accumulate

calc_full:
    	sub $t4, $t2, $t1
    	addi $t4, $t4, 1

accumulate:
    	mul $t5, $t4, $t3
    	add $s3, $s3, $t5

    	addi $s0, $s0, 4        # &A[i+1]
    	addi $s1, $s1, 4        # &C[i+1]
    	addi $s2, $s2, 4        # &B[i+1]
    
    	j calc_loop

print_result:
	li $v0, 4
	la $a0, msg_result
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, msg_unit
	syscall
	
	#exit
	li $v0, 10
	syscall
	
	

	
