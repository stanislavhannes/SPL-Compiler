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
	sub	$29,$29,216		; allocate frame
	stw	$25,$29,24		; save old frame pointer
	add	$25,$29,216		; setup new frame pointer
	stw	$31,$25,-196		; save return register
	add	$8,$25,-188
	add	$9,$0,0
	stw	$9,$8,0
L0:
	add	$8,$25,-188
	ldw	$8,$8,0
	add	$9,$0,8
	bge	$8,$9,L1
	add	$8,$25,-32
	add	$9,$25,-188
	ldw	$9,$9,0
	add	$10,$0,8
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-64
	add	$9,$25,-188
	ldw	$9,$9,0
	add	$10,$0,8
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-188
	add	$9,$25,-188
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L0
L1:
	add	$8,$25,-188
	add	$9,$0,0
	stw	$9,$8,0
L2:
	add	$8,$25,-188
	ldw	$8,$8,0
	add	$9,$0,15
	bge	$8,$9,L3
	add	$8,$25,-124
	add	$9,$25,-188
	ldw	$9,$9,0
	add	$10,$0,15
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-184
	add	$9,$25,-188
	ldw	$9,$9,0
	add	$10,$0,15
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-188
	add	$9,$25,-188
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L2
L3:
	add	$8,$0,0
	stw	$8,$29,0		; store arg #0
	add	$8,$25,-32
	stw	$8,$29,4		; store arg #1
	add	$8,$25,-64
	stw	$8,$29,8		; store arg #2
	add	$8,$25,-124
	stw	$8,$29,12		; store arg #3
	add	$8,$25,-184
	stw	$8,$29,16		; store arg #4
	jal	try
	ldw	$31,$25,-196		; restore return register
	ldw	$25,$29,24		; restore old frame pointer
	add	$29,$29,216		; release frame
	jr	$31			; return

	.export	try
try:
	sub	$29,$29,32		; allocate frame
	stw	$25,$29,24		; save old frame pointer
	add	$25,$29,32		; setup new frame pointer
	stw	$31,$25,-12		; save return register
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,8
	bne	$8,$9,L4
	add	$8,$25,8
	ldw	$8,$8,0
	stw	$8,$29,0		; store arg #0
	jal	printboard
	j	L5
L4:
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
L6:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,8
	bge	$8,$9,L7
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,8
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,0
	bne	$8,$9,L8
	add	$8,$25,12
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$25,0
	ldw	$10,$10,0
	add	$9,$9,$10
	add	$10,$0,15
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,0
	bne	$8,$9,L9
	add	$8,$25,16
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,7
	add	$9,$9,$10
	add	$10,$25,0
	ldw	$10,$10,0
	sub	$9,$9,$10
	add	$10,$0,15
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,0
	bne	$8,$9,L10
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,8
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,1
	stw	$9,$8,0
	add	$8,$25,12
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$25,0
	ldw	$10,$10,0
	add	$9,$9,$10
	add	$10,$0,15
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,1
	stw	$9,$8,0
	add	$8,$25,16
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,7
	add	$9,$9,$10
	add	$10,$25,0
	ldw	$10,$10,0
	sub	$9,$9,$10
	add	$10,$0,15
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,1
	stw	$9,$8,0
	add	$8,$25,8
	ldw	$8,$8,0
	add	$9,$25,0
	ldw	$9,$9,0
	add	$10,$0,8
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,-4
	ldw	$9,$9,0
	stw	$9,$8,0
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,1
	add	$8,$8,$9
	stw	$8,$29,0		; store arg #0
	add	$8,$25,4
	ldw	$8,$8,0
	stw	$8,$29,4		; store arg #1
	add	$8,$25,8
	ldw	$8,$8,0
	stw	$8,$29,8		; store arg #2
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,12		; store arg #3
	add	$8,$25,16
	ldw	$8,$8,0
	stw	$8,$29,16		; store arg #4
	jal	try
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,8
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,12
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$25,0
	ldw	$10,$10,0
	add	$9,$9,$10
	add	$10,$0,15
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,16
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,7
	add	$9,$9,$10
	add	$10,$25,0
	ldw	$10,$10,0
	sub	$9,$9,$10
	add	$10,$0,15
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
L10:
L9:
L8:
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L6
L7:
L5:
	ldw	$31,$25,-12		; restore return register
	ldw	$25,$29,24		; restore old frame pointer
	add	$29,$29,32		; release frame
	jr	$31			; return

	.export	printboard
printboard:
	sub	$29,$29,20		; allocate frame
	stw	$25,$29,8		; save old frame pointer
	add	$25,$29,20		; setup new frame pointer
	stw	$31,$25,-16		; save return register
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
L11:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,8
	bge	$8,$9,L12
	add	$8,$25,-8
	add	$9,$0,0
	stw	$9,$8,0
L13:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$0,8
	bge	$8,$9,L14
	add	$8,$0,32
	stw	$8,$29,0		; store arg #0
	jal	printc
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,8
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	bne	$8,$9,L15
	add	$8,$0,48
	stw	$8,$29,0		; store arg #0
	jal	printc
	j	L16
L15:
	add	$8,$0,46
	stw	$8,$29,0		; store arg #0
	jal	printc
L16:
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L13
L14:
	add	$8,$0,10
	stw	$8,$29,0		; store arg #0
	jal	printc
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L11
L12:
	add	$8,$0,10
	stw	$8,$29,0		; store arg #0
	jal	printc
	ldw	$31,$25,-16		; restore return register
	ldw	$25,$29,8		; restore old frame pointer
	add	$29,$29,20		; release frame
	jr	$31			; return
