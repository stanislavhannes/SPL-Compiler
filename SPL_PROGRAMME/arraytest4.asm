	.import	printi
	.import	printc
	.import	readi
	.import	readc
	.import	exit
	.import	time
	.import	clearAll
	.import	setPixel
	.import	drawLine
	.import	drawCircle
	.import	_indexError

	.code
	.align	4

	.export	main
main:
	sub	$29,$29,28		; allocate frame
	stw	$25,$29,8		; save old frame pointer
	add	$25,$29,28		; setup new frame pointer
	stw	$31,$25,-24		; save return register
	add	$8,$25,-12		; SimpleVar a 
	ldw	$8,$8,0 
	add	$9,$0,2		; intExp
	stw	$9,$8,0		; AssignStm
	add	$8,$25,-16		; SimpleVar b 
	ldw	$8,$8,0 
	add	$9,$0,2		; intExp
	stw	$9,$8,0		; AssignStm
	add	$8,$25,-8		; SimpleVar VarA2 
	ldw	$8,$8,0 
	add	$9,$0,0		; intExp
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4 
	add	$8,$8,$9
	ldw	$10,$10,0 
	add	$9,$0,10		; intExp
	stw	$9,$8,0		; AssignStm
	add	$8,$25,-12		; SimpleVar a 
	add	$9,$25,-16		; SimpleVar b 
	bne	$8,$8,L0
	add	$8,$25,-12		; SimpleVar a 
	ldw	$8,$8,0 
	add	$9,$25,-8		; SimpleVar VarA2 
	add	$10,$0,0		; intExp
	add	$11,$0,2
	bgeu	$10,$11,_indexError
	mul	$10,$10,4 
	add	$9,$9,$10
	stw	$9,$8,0		; AssignStm
L0:
	add	$8,$25,-12		; SimpleVar a 
	ldw	$8,$8,0
	stw	$8,$29,0
	jal	printi
	add	$8,$25,-8		; SimpleVar VarA2 
	stw	$8,$29,0
	jal	test
	ldw	$31,$25,-24		; restore return register
	ldw	$25,$29,8		; restore old frame pointer
	add	$29,$29,28		; release frame
	jr	$31			; return

	.export	test
test:
	sub	$29,$29,4		; allocate frame
	stw	$25,$29,0		; save old frame pointer
	add	$25,$29,4		; setup new frame pointer
	add	$8,$25,0		; Parameter ar 
	ldw	$8,$8,0 
	add	$9,$0,0		; intExp
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4 
	add	$8,$8,$9
	ldw	$10,$10,0 
	add	$9,$0,78		; intExp
	stw	$9,$8,0		; AssignStm
	add	$8,$25,0		; Parameter ar 
	ldw	$8,$8,0 
	add	$9,$0,1		; intExp
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4 
	add	$8,$8,$9
	ldw	$10,$10,0 
	add	$9,$0,2		; intExp
	add	$10,$0,7		; intExp
	mul	$9,$9,$10
	add	$10,$0,6		; intExp
	add	$9,$9,$10
	add	$10,$0,8		; intExp
	sub	$9,$9,$10
	stw	$9,$8,0		; AssignStm
	add	$8,$25,0		; Parameter ar 
	ldw	$8,$8,0 
	add	$9,$0,0		; intExp
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4 
	add	$8,$8,$9
	add	$9,$25,0		; Parameter ar 
	ldw	$9,$9,0 
	add	$10,$0,1		; intExp
	add	$11,$0,2
	bgeu	$10,$11,_indexError
	mul	$10,$10,4 
	add	$9,$9,$10
	bgt	$8,$8,L1
	add	$8,$25,0		; Parameter ar 
	ldw	$8,$8,0 
	add	$9,$0,1		; intExp
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4 
	add	$8,$8,$9
	ldw	$10,$10,0 
	add	$9,$0,2		; intExp
	add	$10,$0,7		; intExp
	mul	$9,$9,$10
	add	$10,$0,6		; intExp
	add	$9,$9,$10
	add	$10,$0,8		; intExp
	sub	$9,$9,$10
	stw	$9,$8,0		; AssignStm
	j	L2
L1:
	add	$8,$25,0		; Parameter ar 
	ldw	$8,$8,0 
	add	$9,$0,1		; intExp
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4 
	add	$8,$8,$9
	ldw	$10,$10,0 
	add	$9,$0,2		; intExp
	add	$10,$0,7		; intExp
	mul	$9,$9,$10
	add	$10,$0,6		; intExp
	add	$9,$9,$10
	add	$10,$0,8		; intExp
	sub	$9,$9,$10
	stw	$9,$8,0		; AssignStm
L2:
	ldw	$25,$29,0		; restore old frame pointer
	add	$29,$29,4		; release frame
	jr	$31			; return
