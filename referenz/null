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
	sub	$29,$29,44		; allocate frame
	stw	$25,$29,12		; save old frame pointer
	add	$25,$29,44		; setup new frame pointer
	stw	$31,$25,-36		; save return register
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$0,5
	stw	$9,$8,0
L0:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	bge	$8,$9,L1
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store arg #0
	jal	printi
	add	$8,$0,58
	stw	$8,$29,0		; store arg #0
	jal	printc
	add	$8,$25,-28
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	stw	$8,$29,0		; store arg #0
	jal	readi
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L0
L1:
	add	$8,$25,-8
	stw	$8,$29,0		; store arg #0
	add	$8,$25,-28
	stw	$8,$29,4		; store arg #1
	jal	sort
L2:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	bge	$8,$9,L3
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store arg #0
	jal	printi
	add	$8,$0,58
	stw	$8,$29,0		; store arg #0
	jal	printc
	add	$8,$25,-28
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,0		; store arg #0
	jal	printi
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L2
L3:
	ldw	$31,$25,-36		; restore return register
	ldw	$25,$29,12		; restore old frame pointer
	add	$29,$29,44		; release frame
	jr	$31			; return

	.export	sort
sort:
	sub	$29,$29,16		; allocate frame
	stw	$25,$29,0		; save old frame pointer
	add	$25,$29,16		; setup new frame pointer
	add	$8,$25,-4
	add	$9,$25,0
	ldw	$9,$9,0
	ldw	$9,$9,0
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$0,0
	stw	$9,$8,0
L4:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,1
	ble	$8,$9,L5
L6:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	bge	$8,$9,L7
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	add	$10,$25,-8
	ldw	$10,$10,0
	add	$11,$0,1
	add	$10,$10,$11
	add	$11,$0,5
	bgeu	$10,$11,_indexError
	mul	$10,$10,4
	add	$9,$9,$10
	ldw	$9,$9,0
	ble	$8,$9,L8
	add	$8,$25,-12
	add	$9,$25,4
	ldw	$9,$9,0
	add	$10,$25,-8
	ldw	$10,$10,0
	add	$11,$0,5
	bgeu	$10,$11,_indexError
	mul	$10,$10,4
	add	$9,$9,$10
	ldw	$9,$9,0
	stw	$9,$8,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,4
	ldw	$9,$9,0
	add	$10,$25,-8
	ldw	$10,$10,0
	add	$11,$0,1
	add	$10,$10,$11
	add	$11,$0,5
	bgeu	$10,$11,_indexError
	mul	$10,$10,4
	add	$9,$9,$10
	ldw	$9,$9,0
	stw	$9,$8,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,-12
	ldw	$9,$9,0
	stw	$9,$8,0
L8:
	j	L6
L7:
	j	L4
L5:
	ldw	$25,$29,0		; restore old frame pointer
	add	$29,$29,16		; release frame
	jr	$31			; return
