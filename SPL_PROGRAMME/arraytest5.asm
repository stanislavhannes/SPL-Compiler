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
	add	$8,$25,-8
	add	$9,$0,0
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,10
	stw	$9,$8,0
L0:
	add	$8,$25,-12
	ldw	$8,$8,0
	add	$9,$25,-16
	ldw	$9,$9,0
	bne	$8,$9,L1
	add	$8,$25,-12
	add	$9,$25,-16
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L0
L1:
	add	$8,$25,-8
	stw	$8,$29,0		; store arg #0
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
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,0
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,78
	stw	$9,$8,0
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,1
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,2
	add	$10,$0,7
	mul	$9,$9,$10
	add	$10,$0,6
	add	$9,$9,$10
	add	$10,$0,8
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,0
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$25,0
	ldw	$9,$9,0
	add	$10,$0,1
	add	$11,$0,2
	bgeu	$10,$11,_indexError
	mul	$10,$10,4
	add	$9,$9,$10
	ldw	$9,$9,0
	bgt	$8,$9,L2
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,1
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,2
	add	$10,$0,7
	mul	$9,$9,$10
	add	$10,$0,6
	add	$9,$9,$10
	add	$10,$0,8
	sub	$9,$9,$10
	stw	$9,$8,0
	j	L3
L2:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,1
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,2
	add	$10,$0,7
	mul	$9,$9,$10
	add	$10,$0,6
	add	$9,$9,$10
	add	$10,$0,8
	sub	$9,$9,$10
	stw	$9,$8,0
L3:
	ldw	$25,$29,0		; restore old frame pointer
	add	$29,$29,4		; release frame
	jr	$31			; return
