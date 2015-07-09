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
	add	$8,$25,-188		; local var: i
	add	$9,$0,0		; int literal: 0
	stw	$9,$8,0		; assignment
L0:
	add	$8,$25,-188		; local var: i
	ldw	$8,$8,0
	add	$9,$0,8		; int literal: 8
	blt	$8,$9,L1
	j	L2
L1:
	add	$9,$25,-32		; local var: row
	add	$10,$25,-188		; local var: i
	ldw	$10,$10,0
	add	$11,$0,8
	bgeu	$10,$11,_indexError
	mul	$10,$10,4		; calculat offset within array
	add	$9,$9,$10
	add	$10,$0,0		; int literal: 0
	stw	$10,$9,0		; assignment
	add	$9,$25,-64		; local var: col
	add	$10,$25,-188		; local var: i
	ldw	$10,$10,0
	add	$11,$0,8
	bgeu	$10,$11,_indexError
	mul	$10,$10,4		; calculat offset within array
	add	$9,$9,$10
	add	$10,$0,0		; int literal: 0
	stw	$10,$9,0		; assignment
	add	$9,$25,-188		; local var: i
	add	$10,$25,-188		; local var: i
	ldw	$10,$10,0
	add	$11,$0,1		; int literal: 1
	add	$10,$10,$11
	stw	$10,$9,0		; assignment
	j	L0
L2:
	add	$9,$25,-188		; local var: i
	add	$10,$0,0		; int literal: 0
	stw	$10,$9,0		; assignment
L3:
	add	$9,$25,-188		; local var: i
	ldw	$9,$9,0
	add	$10,$0,15		; int literal: 15
	blt	$9,$10,L4
	j	L5
L4:
	add	$10,$25,-124		; local var: diag1
	add	$11,$25,-188		; local var: i
	ldw	$11,$11,0
	add	$12,$0,15
	bgeu	$11,$12,_indexError
	mul	$11,$11,4		; calculat offset within array
	add	$10,$10,$11
	add	$11,$0,0		; int literal: 0
	stw	$11,$10,0		; assignment
	add	$10,$25,-184		; local var: diag2
	add	$11,$25,-188		; local var: i
	ldw	$11,$11,0
	add	$12,$0,15
	bgeu	$11,$12,_indexError
	mul	$11,$11,4		; calculat offset within array
	add	$10,$10,$11
	add	$11,$0,0		; int literal: 0
	stw	$11,$10,0		; assignment
	add	$10,$25,-188		; local var: i
	add	$11,$25,-188		; local var: i
	ldw	$11,$11,0
	add	$12,$0,1		; int literal: 1
	add	$11,$11,$12
	stw	$11,$10,0		; assignment
	j	L3
L5:
	add	$10,$0,0		; int literal: 0
	stw	$10,$29,0		; store arg #0
	add	$10,$25,-32		; local var: row
	stw	$10,$29,4		; store arg #1
	add	$10,$25,-64		; local var: col
	stw	$10,$29,8		; store arg #2
	add	$10,$25,-124		; local var: diag1
	stw	$10,$29,12		; store arg #3
	add	$10,$25,-184		; local var: diag2
	stw	$10,$29,16		; store arg #4
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
	add	$10,$25,0		; local var: c
	ldw	$10,$10,0
	add	$11,$0,8		; int literal: 8
	beq	$10,$11,L6
	add	$11,$25,-4		; local var: r
	add	$12,$0,0		; int literal: 0
	stw	$12,$11,0		; assignment
L8:
	add	$11,$25,-4		; local var: r
	ldw	$11,$11,0
	add	$12,$0,8		; int literal: 8
	blt	$11,$12,L9
	j	L10
L9:
	add	$12,$25,4		; local var: row
	ldw	$12,$12,0
	add	$13,$25,-4		; local var: r
	ldw	$13,$13,0
	add	$14,$0,8
	bgeu	$13,$14,_indexError
	mul	$13,$13,4		; calculat offset within array
	add	$12,$12,$13
	ldw	$12,$12,0
	add	$13,$0,0		; int literal: 0
	beq	$12,$13,L11
	j	L12
L11:
	add	$13,$25,12		; local var: diag1
	ldw	$13,$13,0
	add	$14,$25,-4		; local var: r
	ldw	$14,$14,0
	add	$15,$25,0		; local var: c
	ldw	$15,$15,0
	add	$14,$14,$15
	add	$15,$0,15
	bgeu	$14,$15,_indexError
	mul	$14,$14,4		; calculat offset within array
	add	$13,$13,$14
	ldw	$13,$13,0
	add	$14,$0,0		; int literal: 0
	beq	$13,$14,L13
	j	L14
L13:
	add	$14,$25,16		; local var: diag2
	ldw	$14,$14,0
	add	$15,$25,-4		; local var: r
	ldw	$15,$15,0
	add	$16,$0,7		; int literal: 7
	add	$15,$15,$16
	add	$16,$25,0		; local var: c
	ldw	$16,$16,0
	sub	$15,$15,$16
	add	$16,$0,15
	bgeu	$15,$16,_indexError
	mul	$15,$15,4		; calculat offset within array
	add	$14,$14,$15
	ldw	$14,$14,0
	add	$15,$0,0		; int literal: 0
	beq	$14,$15,L15
	j	L16
L15:
	add	$15,$25,4		; local var: row
	ldw	$15,$15,0
	add	$16,$25,-4		; local var: r
	ldw	$16,$16,0
	add	$17,$0,8
	bgeu	$16,$17,_indexError
	mul	$16,$16,4		; calculat offset within array
	add	$15,$15,$16
	add	$16,$0,1		; int literal: 1
	stw	$16,$15,0		; assignment
	add	$15,$25,12		; local var: diag1
	ldw	$15,$15,0
	add	$16,$25,-4		; local var: r
	ldw	$16,$16,0
	add	$17,$25,0		; local var: c
	ldw	$17,$17,0
	add	$16,$16,$17
	add	$17,$0,15
	bgeu	$16,$17,_indexError
	mul	$16,$16,4		; calculat offset within array
	add	$15,$15,$16
	add	$16,$0,1		; int literal: 1
	stw	$16,$15,0		; assignment
	add	$15,$25,16		; local var: diag2
	ldw	$15,$15,0
	add	$16,$25,-4		; local var: r
	ldw	$16,$16,0
	add	$17,$0,7		; int literal: 7
	add	$16,$16,$17
	add	$17,$25,0		; local var: c
	ldw	$17,$17,0
	sub	$16,$16,$17
	add	$17,$0,15
	bgeu	$16,$17,_indexError
	mul	$16,$16,4		; calculat offset within array
	add	$15,$15,$16
	add	$16,$0,1		; int literal: 1
	stw	$16,$15,0		; assignment
	add	$15,$25,8		; local var: col
	ldw	$15,$15,0
	add	$16,$25,0		; local var: c
	ldw	$16,$16,0
	add	$17,$0,8
	bgeu	$16,$17,_indexError
	mul	$16,$16,4		; calculat offset within array
	add	$15,$15,$16
	add	$16,$25,-4		; local var: r
	ldw	$16,$16,0
	stw	$16,$15,0		; assignment
	add	$15,$25,0		; local var: c
	ldw	$15,$15,0
	add	$16,$0,1		; int literal: 1
	add	$15,$15,$16
	stw	$15,$29,0		; store arg #0
	add	$15,$25,4		; local var: row
	ldw	$15,$15,0
	stw	$15,$29,4		; store arg #1
	add	$15,$25,8		; local var: col
	ldw	$15,$15,0
	stw	$15,$29,8		; store arg #2
	add	$15,$25,12		; local var: diag1
	ldw	$15,$15,0
	stw	$15,$29,12		; store arg #3
	add	$15,$25,16		; local var: diag2
	ldw	$15,$15,0
	stw	$15,$29,16		; store arg #4
	jal	try
	add	$15,$25,4		; local var: row
	ldw	$15,$15,0
	add	$16,$25,-4		; local var: r
	ldw	$16,$16,0
	add	$17,$0,8
	bgeu	$16,$17,_indexError
	mul	$16,$16,4		; calculat offset within array
	add	$15,$15,$16
	add	$16,$0,0		; int literal: 0
	stw	$16,$15,0		; assignment
	add	$15,$25,12		; local var: diag1
	ldw	$15,$15,0
	add	$16,$25,-4		; local var: r
	ldw	$16,$16,0
	add	$17,$25,0		; local var: c
	ldw	$17,$17,0
	add	$16,$16,$17
	add	$17,$0,15
	bgeu	$16,$17,_indexError
	mul	$16,$16,4		; calculat offset within array
	add	$15,$15,$16
	add	$16,$0,0		; int literal: 0
	stw	$16,$15,0		; assignment
	add	$15,$25,16		; local var: diag2
	ldw	$15,$15,0
	add	$16,$25,-4		; local var: r
	ldw	$16,$16,0
	add	$17,$0,7		; int literal: 7
	add	$16,$16,$17
	add	$17,$25,0		; local var: c
	ldw	$17,$17,0
	sub	$16,$16,$17
	add	$17,$0,15
	bgeu	$16,$17,_indexError
	mul	$16,$16,4		; calculat offset within array
	add	$15,$15,$16
	add	$16,$0,0		; int literal: 0
	stw	$16,$15,0		; assignment
L16:
L14:
L12:
	add	$15,$25,-4		; local var: r
	add	$16,$25,-4		; local var: r
	ldw	$16,$16,0
	add	$17,$0,1		; int literal: 1
	add	$16,$16,$17
	stw	$16,$15,0		; assignment
	j	L8
L10:
	j	L7
L6:
	add	$15,$25,8		; local var: col
	ldw	$15,$15,0
	stw	$15,$29,0		; store arg #0
	jal	printboard
L7:
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
	add	$15,$25,-4		; local var: i
	add	$16,$0,0		; int literal: 0
	stw	$16,$15,0		; assignment
L17:
	add	$15,$25,-4		; local var: i
	ldw	$15,$15,0
	add	$16,$0,8		; int literal: 8
	blt	$15,$16,L18
	j	L19
L18:
	add	$16,$25,-8		; local var: j
	add	$17,$0,0		; int literal: 0
	stw	$17,$16,0		; assignment
L20:
	add	$16,$25,-8		; local var: j
	ldw	$16,$16,0
	add	$17,$0,8		; int literal: 8
	blt	$16,$17,L21
	j	L22
L21:
	add	$17,$0,32		; int literal: 32
	stw	$17,$29,0		; store arg #0
	jal	printc
	add	$17,$25,0		; local var: col
	ldw	$17,$17,0
	add	$18,$25,-4		; local var: i
	ldw	$18,$18,0
	add	$19,$0,8
	bgeu	$18,$19,_indexError
	mul	$18,$18,4		; calculat offset within array
	add	$17,$17,$18
	ldw	$17,$17,0
	add	$18,$25,-8		; local var: j
	ldw	$18,$18,0
	beq	$17,$18,L23
	add	$18,$0,46		; int literal: 46
	stw	$18,$29,0		; store arg #0
	jal	printc
	j	L24
L23:
	add	$18,$0,48		; int literal: 48
	stw	$18,$29,0		; store arg #0
	jal	printc
L24:
	add	$18,$25,-8		; local var: j
	add	$19,$25,-8		; local var: j
	ldw	$19,$19,0
	add	$20,$0,1		; int literal: 1
	add	$19,$19,$20
	stw	$19,$18,0		; assignment
	j	L20
L22:
	add	$18,$0,10		; int literal: 10
	stw	$18,$29,0		; store arg #0
	jal	printc
	add	$18,$25,-4		; local var: i
	add	$19,$25,-4		; local var: i
	ldw	$19,$19,0
	add	$20,$0,1		; int literal: 1
	add	$19,$19,$20
	stw	$19,$18,0		; assignment
	j	L17
L19:
	add	$18,$0,10		; int literal: 10
	stw	$18,$29,0		; store arg #0
	jal	printc
	ldw	$31,$25,-16		; restore return register
	ldw	$25,$29,8		; restore old frame pointer
	add	$29,$29,20		; release frame
	jr	$31			; return
