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

	.export	plot
plot:
	sub	$29,$29,44		; allocate frame
	stw	$25,$29,24		; save old frame pointer
	add	$25,$29,44		; setup new frame pointer
	stw	$31,$25,-24		; save return register
	add	$8,$25,-4		; local var: fromCol
	add	$9,$25,0		; local var: px
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,128		; int literal: 128
	sub	$9,$9,$10
	add	$10,$0,3		; int literal: 3
	mul	$9,$9,$10
	add	$10,$0,2		; int literal: 2
	div	$9,$9,$10
	add	$10,$0,320		; int literal: 320
	add	$9,$9,$10
	stw	$9,$8,0		; assignment
	add	$8,$25,-8		; local var: fromRow
	add	$9,$25,4		; local var: py
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,128		; int literal: 128
	sub	$9,$9,$10
	add	$10,$0,3		; int literal: 3
	mul	$9,$9,$10
	add	$10,$0,2		; int literal: 2
	div	$9,$9,$10
	add	$10,$0,240		; int literal: 240
	add	$9,$9,$10
	stw	$9,$8,0		; assignment
	add	$8,$25,-12		; local var: toCol
	add	$9,$25,8		; local var: x
	ldw	$9,$9,0
	add	$10,$0,128		; int literal: 128
	sub	$9,$9,$10
	add	$10,$0,3		; int literal: 3
	mul	$9,$9,$10
	add	$10,$0,2		; int literal: 2
	div	$9,$9,$10
	add	$10,$0,320		; int literal: 320
	add	$9,$9,$10
	stw	$9,$8,0		; assignment
	add	$8,$25,-16		; local var: toRow
	add	$9,$25,12		; local var: y
	ldw	$9,$9,0
	add	$10,$0,128		; int literal: 128
	sub	$9,$9,$10
	add	$10,$0,3		; int literal: 3
	mul	$9,$9,$10
	add	$10,$0,2		; int literal: 2
	div	$9,$9,$10
	add	$10,$0,240		; int literal: 240
	add	$9,$9,$10
	stw	$9,$8,0		; assignment
	add	$8,$25,-4		; local var: fromCol
	ldw	$8,$8,0
	stw	$8,$29,0		; store arg #0
	add	$8,$25,-8		; local var: fromRow
	ldw	$8,$8,0
	stw	$8,$29,4		; store arg #1
	add	$8,$25,-12		; local var: toCol
	ldw	$8,$8,0
	stw	$8,$29,8		; store arg #2
	add	$8,$25,-16		; local var: toRow
	ldw	$8,$8,0
	stw	$8,$29,12		; store arg #3
	add	$8,$0,0		; int literal: 0
	stw	$8,$29,16		; store arg #4
	jal	drawLine
	add	$8,$25,0		; local var: px
	ldw	$8,$8,0
	add	$9,$25,8		; local var: x
	ldw	$9,$9,0
	stw	$9,$8,0		; assignment
	add	$8,$25,4		; local var: py
	ldw	$8,$8,0
	add	$9,$25,12		; local var: y
	ldw	$9,$9,0
	stw	$9,$8,0		; assignment
	ldw	$31,$25,-24		; restore return register
	ldw	$25,$29,24		; restore old frame pointer
	add	$29,$29,44		; release frame
	jr	$31			; return

	.export	a
a:
	sub	$29,$29,32		; allocate frame
	stw	$25,$29,28		; save old frame pointer
	add	$25,$29,32		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$8,$25,0		; local var: i
	ldw	$8,$8,0
	add	$9,$0,0		; int literal: 0
	bgt	$8,$9,L0
	j	L1
L0:
	add	$9,$25,0		; local var: i
	ldw	$9,$9,0
	add	$10,$0,1		; int literal: 1
	sub	$9,$9,$10
	stw	$9,$29,0		; store arg #0
	add	$9,$25,4		; local var: x
	ldw	$9,$9,0
	stw	$9,$29,4		; store arg #1
	add	$9,$25,8		; local var: y
	ldw	$9,$9,0
	stw	$9,$29,8		; store arg #2
	add	$9,$25,12		; local var: h
	ldw	$9,$9,0
	stw	$9,$29,12		; store arg #3
	add	$9,$25,16		; local var: px
	ldw	$9,$9,0
	stw	$9,$29,16		; store arg #4
	add	$9,$25,20		; local var: py
	ldw	$9,$9,0
	stw	$9,$29,20		; store arg #5
	jal	a
	add	$9,$25,4		; local var: x
	ldw	$9,$9,0
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	ldw	$10,$10,0
	add	$11,$25,12		; local var: h
	ldw	$11,$11,0
	add	$10,$10,$11
	stw	$10,$9,0		; assignment
	add	$9,$25,8		; local var: y
	ldw	$9,$9,0
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	ldw	$10,$10,0
	add	$11,$25,12		; local var: h
	ldw	$11,$11,0
	sub	$10,$10,$11
	stw	$10,$9,0		; assignment
	add	$9,$25,16		; local var: px
	ldw	$9,$9,0
	stw	$9,$29,0		; store arg #0
	add	$9,$25,20		; local var: py
	ldw	$9,$9,0
	stw	$9,$29,4		; store arg #1
	add	$9,$25,4		; local var: x
	ldw	$9,$9,0
	ldw	$9,$9,0
	stw	$9,$29,8		; store arg #2
	add	$9,$25,8		; local var: y
	ldw	$9,$9,0
	ldw	$9,$9,0
	stw	$9,$29,12		; store arg #3
	jal	plot
	add	$9,$25,0		; local var: i
	ldw	$9,$9,0
	add	$10,$0,1		; int literal: 1
	sub	$9,$9,$10
	stw	$9,$29,0		; store arg #0
	add	$9,$25,4		; local var: x
	ldw	$9,$9,0
	stw	$9,$29,4		; store arg #1
	add	$9,$25,8		; local var: y
	ldw	$9,$9,0
	stw	$9,$29,8		; store arg #2
	add	$9,$25,12		; local var: h
	ldw	$9,$9,0
	stw	$9,$29,12		; store arg #3
	add	$9,$25,16		; local var: px
	ldw	$9,$9,0
	stw	$9,$29,16		; store arg #4
	add	$9,$25,20		; local var: py
	ldw	$9,$9,0
	stw	$9,$29,20		; store arg #5
	jal	b
	add	$9,$25,4		; local var: x
	ldw	$9,$9,0
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	ldw	$10,$10,0
	add	$11,$0,2		; int literal: 2
	add	$12,$25,12		; local var: h
	ldw	$12,$12,0
	mul	$11,$11,$12
	add	$10,$10,$11
	stw	$10,$9,0		; assignment
	add	$9,$25,16		; local var: px
	ldw	$9,$9,0
	stw	$9,$29,0		; store arg #0
	add	$9,$25,20		; local var: py
	ldw	$9,$9,0
	stw	$9,$29,4		; store arg #1
	add	$9,$25,4		; local var: x
	ldw	$9,$9,0
	ldw	$9,$9,0
	stw	$9,$29,8		; store arg #2
	add	$9,$25,8		; local var: y
	ldw	$9,$9,0
	ldw	$9,$9,0
	stw	$9,$29,12		; store arg #3
	jal	plot
	add	$9,$25,0		; local var: i
	ldw	$9,$9,0
	add	$10,$0,1		; int literal: 1
	sub	$9,$9,$10
	stw	$9,$29,0		; store arg #0
	add	$9,$25,4		; local var: x
	ldw	$9,$9,0
	stw	$9,$29,4		; store arg #1
	add	$9,$25,8		; local var: y
	ldw	$9,$9,0
	stw	$9,$29,8		; store arg #2
	add	$9,$25,12		; local var: h
	ldw	$9,$9,0
	stw	$9,$29,12		; store arg #3
	add	$9,$25,16		; local var: px
	ldw	$9,$9,0
	stw	$9,$29,16		; store arg #4
	add	$9,$25,20		; local var: py
	ldw	$9,$9,0
	stw	$9,$29,20		; store arg #5
	jal	d
	add	$9,$25,4		; local var: x
	ldw	$9,$9,0
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	ldw	$10,$10,0
	add	$11,$25,12		; local var: h
	ldw	$11,$11,0
	add	$10,$10,$11
	stw	$10,$9,0		; assignment
	add	$9,$25,8		; local var: y
	ldw	$9,$9,0
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	ldw	$10,$10,0
	add	$11,$25,12		; local var: h
	ldw	$11,$11,0
	add	$10,$10,$11
	stw	$10,$9,0		; assignment
	add	$9,$25,16		; local var: px
	ldw	$9,$9,0
	stw	$9,$29,0		; store arg #0
	add	$9,$25,20		; local var: py
	ldw	$9,$9,0
	stw	$9,$29,4		; store arg #1
	add	$9,$25,4		; local var: x
	ldw	$9,$9,0
	ldw	$9,$9,0
	stw	$9,$29,8		; store arg #2
	add	$9,$25,8		; local var: y
	ldw	$9,$9,0
	ldw	$9,$9,0
	stw	$9,$29,12		; store arg #3
	jal	plot
	add	$9,$25,0		; local var: i
	ldw	$9,$9,0
	add	$10,$0,1		; int literal: 1
	sub	$9,$9,$10
	stw	$9,$29,0		; store arg #0
	add	$9,$25,4		; local var: x
	ldw	$9,$9,0
	stw	$9,$29,4		; store arg #1
	add	$9,$25,8		; local var: y
	ldw	$9,$9,0
	stw	$9,$29,8		; store arg #2
	add	$9,$25,12		; local var: h
	ldw	$9,$9,0
	stw	$9,$29,12		; store arg #3
	add	$9,$25,16		; local var: px
	ldw	$9,$9,0
	stw	$9,$29,16		; store arg #4
	add	$9,$25,20		; local var: py
	ldw	$9,$9,0
	stw	$9,$29,20		; store arg #5
	jal	a
L1:
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,28		; restore old frame pointer
	add	$29,$29,32		; release frame
	jr	$31			; return

	.export	b
b:
	sub	$29,$29,32		; allocate frame
	stw	$25,$29,28		; save old frame pointer
	add	$25,$29,32		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$9,$25,0		; local var: i
	ldw	$9,$9,0
	add	$10,$0,0		; int literal: 0
	bgt	$9,$10,L2
	j	L3
L2:
	add	$10,$25,0		; local var: i
	ldw	$10,$10,0
	add	$11,$0,1		; int literal: 1
	sub	$10,$10,$11
	stw	$10,$29,0		; store arg #0
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	stw	$10,$29,4		; store arg #1
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	stw	$10,$29,8		; store arg #2
	add	$10,$25,12		; local var: h
	ldw	$10,$10,0
	stw	$10,$29,12		; store arg #3
	add	$10,$25,16		; local var: px
	ldw	$10,$10,0
	stw	$10,$29,16		; store arg #4
	add	$10,$25,20		; local var: py
	ldw	$10,$10,0
	stw	$10,$29,20		; store arg #5
	jal	b
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	ldw	$11,$11,0
	add	$12,$25,12		; local var: h
	ldw	$12,$12,0
	sub	$11,$11,$12
	stw	$11,$10,0		; assignment
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	ldw	$11,$11,0
	add	$12,$25,12		; local var: h
	ldw	$12,$12,0
	sub	$11,$11,$12
	stw	$11,$10,0		; assignment
	add	$10,$25,16		; local var: px
	ldw	$10,$10,0
	stw	$10,$29,0		; store arg #0
	add	$10,$25,20		; local var: py
	ldw	$10,$10,0
	stw	$10,$29,4		; store arg #1
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	ldw	$10,$10,0
	stw	$10,$29,8		; store arg #2
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	ldw	$10,$10,0
	stw	$10,$29,12		; store arg #3
	jal	plot
	add	$10,$25,0		; local var: i
	ldw	$10,$10,0
	add	$11,$0,1		; int literal: 1
	sub	$10,$10,$11
	stw	$10,$29,0		; store arg #0
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	stw	$10,$29,4		; store arg #1
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	stw	$10,$29,8		; store arg #2
	add	$10,$25,12		; local var: h
	ldw	$10,$10,0
	stw	$10,$29,12		; store arg #3
	add	$10,$25,16		; local var: px
	ldw	$10,$10,0
	stw	$10,$29,16		; store arg #4
	add	$10,$25,20		; local var: py
	ldw	$10,$10,0
	stw	$10,$29,20		; store arg #5
	jal	c
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	ldw	$11,$11,0
	add	$12,$0,2		; int literal: 2
	add	$13,$25,12		; local var: h
	ldw	$13,$13,0
	mul	$12,$12,$13
	sub	$11,$11,$12
	stw	$11,$10,0		; assignment
	add	$10,$25,16		; local var: px
	ldw	$10,$10,0
	stw	$10,$29,0		; store arg #0
	add	$10,$25,20		; local var: py
	ldw	$10,$10,0
	stw	$10,$29,4		; store arg #1
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	ldw	$10,$10,0
	stw	$10,$29,8		; store arg #2
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	ldw	$10,$10,0
	stw	$10,$29,12		; store arg #3
	jal	plot
	add	$10,$25,0		; local var: i
	ldw	$10,$10,0
	add	$11,$0,1		; int literal: 1
	sub	$10,$10,$11
	stw	$10,$29,0		; store arg #0
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	stw	$10,$29,4		; store arg #1
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	stw	$10,$29,8		; store arg #2
	add	$10,$25,12		; local var: h
	ldw	$10,$10,0
	stw	$10,$29,12		; store arg #3
	add	$10,$25,16		; local var: px
	ldw	$10,$10,0
	stw	$10,$29,16		; store arg #4
	add	$10,$25,20		; local var: py
	ldw	$10,$10,0
	stw	$10,$29,20		; store arg #5
	jal	a
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	ldw	$11,$11,0
	add	$12,$25,12		; local var: h
	ldw	$12,$12,0
	add	$11,$11,$12
	stw	$11,$10,0		; assignment
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	ldw	$11,$11,0
	add	$12,$25,12		; local var: h
	ldw	$12,$12,0
	sub	$11,$11,$12
	stw	$11,$10,0		; assignment
	add	$10,$25,16		; local var: px
	ldw	$10,$10,0
	stw	$10,$29,0		; store arg #0
	add	$10,$25,20		; local var: py
	ldw	$10,$10,0
	stw	$10,$29,4		; store arg #1
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	ldw	$10,$10,0
	stw	$10,$29,8		; store arg #2
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	ldw	$10,$10,0
	stw	$10,$29,12		; store arg #3
	jal	plot
	add	$10,$25,0		; local var: i
	ldw	$10,$10,0
	add	$11,$0,1		; int literal: 1
	sub	$10,$10,$11
	stw	$10,$29,0		; store arg #0
	add	$10,$25,4		; local var: x
	ldw	$10,$10,0
	stw	$10,$29,4		; store arg #1
	add	$10,$25,8		; local var: y
	ldw	$10,$10,0
	stw	$10,$29,8		; store arg #2
	add	$10,$25,12		; local var: h
	ldw	$10,$10,0
	stw	$10,$29,12		; store arg #3
	add	$10,$25,16		; local var: px
	ldw	$10,$10,0
	stw	$10,$29,16		; store arg #4
	add	$10,$25,20		; local var: py
	ldw	$10,$10,0
	stw	$10,$29,20		; store arg #5
	jal	b
L3:
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,28		; restore old frame pointer
	add	$29,$29,32		; release frame
	jr	$31			; return

	.export	c
c:
	sub	$29,$29,32		; allocate frame
	stw	$25,$29,28		; save old frame pointer
	add	$25,$29,32		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$10,$25,0		; local var: i
	ldw	$10,$10,0
	add	$11,$0,0		; int literal: 0
	bgt	$10,$11,L4
	j	L5
L4:
	add	$11,$25,0		; local var: i
	ldw	$11,$11,0
	add	$12,$0,1		; int literal: 1
	sub	$11,$11,$12
	stw	$11,$29,0		; store arg #0
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	stw	$11,$29,4		; store arg #1
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	stw	$11,$29,8		; store arg #2
	add	$11,$25,12		; local var: h
	ldw	$11,$11,0
	stw	$11,$29,12		; store arg #3
	add	$11,$25,16		; local var: px
	ldw	$11,$11,0
	stw	$11,$29,16		; store arg #4
	add	$11,$25,20		; local var: py
	ldw	$11,$11,0
	stw	$11,$29,20		; store arg #5
	jal	c
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	ldw	$12,$12,0
	add	$13,$25,12		; local var: h
	ldw	$13,$13,0
	sub	$12,$12,$13
	stw	$12,$11,0		; assignment
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	ldw	$12,$12,0
	add	$13,$25,12		; local var: h
	ldw	$13,$13,0
	add	$12,$12,$13
	stw	$12,$11,0		; assignment
	add	$11,$25,16		; local var: px
	ldw	$11,$11,0
	stw	$11,$29,0		; store arg #0
	add	$11,$25,20		; local var: py
	ldw	$11,$11,0
	stw	$11,$29,4		; store arg #1
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	ldw	$11,$11,0
	stw	$11,$29,8		; store arg #2
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	ldw	$11,$11,0
	stw	$11,$29,12		; store arg #3
	jal	plot
	add	$11,$25,0		; local var: i
	ldw	$11,$11,0
	add	$12,$0,1		; int literal: 1
	sub	$11,$11,$12
	stw	$11,$29,0		; store arg #0
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	stw	$11,$29,4		; store arg #1
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	stw	$11,$29,8		; store arg #2
	add	$11,$25,12		; local var: h
	ldw	$11,$11,0
	stw	$11,$29,12		; store arg #3
	add	$11,$25,16		; local var: px
	ldw	$11,$11,0
	stw	$11,$29,16		; store arg #4
	add	$11,$25,20		; local var: py
	ldw	$11,$11,0
	stw	$11,$29,20		; store arg #5
	jal	d
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	ldw	$12,$12,0
	add	$13,$0,2		; int literal: 2
	add	$14,$25,12		; local var: h
	ldw	$14,$14,0
	mul	$13,$13,$14
	sub	$12,$12,$13
	stw	$12,$11,0		; assignment
	add	$11,$25,16		; local var: px
	ldw	$11,$11,0
	stw	$11,$29,0		; store arg #0
	add	$11,$25,20		; local var: py
	ldw	$11,$11,0
	stw	$11,$29,4		; store arg #1
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	ldw	$11,$11,0
	stw	$11,$29,8		; store arg #2
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	ldw	$11,$11,0
	stw	$11,$29,12		; store arg #3
	jal	plot
	add	$11,$25,0		; local var: i
	ldw	$11,$11,0
	add	$12,$0,1		; int literal: 1
	sub	$11,$11,$12
	stw	$11,$29,0		; store arg #0
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	stw	$11,$29,4		; store arg #1
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	stw	$11,$29,8		; store arg #2
	add	$11,$25,12		; local var: h
	ldw	$11,$11,0
	stw	$11,$29,12		; store arg #3
	add	$11,$25,16		; local var: px
	ldw	$11,$11,0
	stw	$11,$29,16		; store arg #4
	add	$11,$25,20		; local var: py
	ldw	$11,$11,0
	stw	$11,$29,20		; store arg #5
	jal	b
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	ldw	$12,$12,0
	add	$13,$25,12		; local var: h
	ldw	$13,$13,0
	sub	$12,$12,$13
	stw	$12,$11,0		; assignment
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	ldw	$12,$12,0
	add	$13,$25,12		; local var: h
	ldw	$13,$13,0
	sub	$12,$12,$13
	stw	$12,$11,0		; assignment
	add	$11,$25,16		; local var: px
	ldw	$11,$11,0
	stw	$11,$29,0		; store arg #0
	add	$11,$25,20		; local var: py
	ldw	$11,$11,0
	stw	$11,$29,4		; store arg #1
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	ldw	$11,$11,0
	stw	$11,$29,8		; store arg #2
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	ldw	$11,$11,0
	stw	$11,$29,12		; store arg #3
	jal	plot
	add	$11,$25,0		; local var: i
	ldw	$11,$11,0
	add	$12,$0,1		; int literal: 1
	sub	$11,$11,$12
	stw	$11,$29,0		; store arg #0
	add	$11,$25,4		; local var: x
	ldw	$11,$11,0
	stw	$11,$29,4		; store arg #1
	add	$11,$25,8		; local var: y
	ldw	$11,$11,0
	stw	$11,$29,8		; store arg #2
	add	$11,$25,12		; local var: h
	ldw	$11,$11,0
	stw	$11,$29,12		; store arg #3
	add	$11,$25,16		; local var: px
	ldw	$11,$11,0
	stw	$11,$29,16		; store arg #4
	add	$11,$25,20		; local var: py
	ldw	$11,$11,0
	stw	$11,$29,20		; store arg #5
	jal	c
L5:
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,28		; restore old frame pointer
	add	$29,$29,32		; release frame
	jr	$31			; return

	.export	d
d:
	sub	$29,$29,32		; allocate frame
	stw	$25,$29,28		; save old frame pointer
	add	$25,$29,32		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$11,$25,0		; local var: i
	ldw	$11,$11,0
	add	$12,$0,0		; int literal: 0
	bgt	$11,$12,L6
	j	L7
L6:
	add	$12,$25,0		; local var: i
	ldw	$12,$12,0
	add	$13,$0,1		; int literal: 1
	sub	$12,$12,$13
	stw	$12,$29,0		; store arg #0
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	stw	$12,$29,4		; store arg #1
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	stw	$12,$29,8		; store arg #2
	add	$12,$25,12		; local var: h
	ldw	$12,$12,0
	stw	$12,$29,12		; store arg #3
	add	$12,$25,16		; local var: px
	ldw	$12,$12,0
	stw	$12,$29,16		; store arg #4
	add	$12,$25,20		; local var: py
	ldw	$12,$12,0
	stw	$12,$29,20		; store arg #5
	jal	d
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	add	$13,$25,4		; local var: x
	ldw	$13,$13,0
	ldw	$13,$13,0
	add	$14,$25,12		; local var: h
	ldw	$14,$14,0
	add	$13,$13,$14
	stw	$13,$12,0		; assignment
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	add	$13,$25,8		; local var: y
	ldw	$13,$13,0
	ldw	$13,$13,0
	add	$14,$25,12		; local var: h
	ldw	$14,$14,0
	add	$13,$13,$14
	stw	$13,$12,0		; assignment
	add	$12,$25,16		; local var: px
	ldw	$12,$12,0
	stw	$12,$29,0		; store arg #0
	add	$12,$25,20		; local var: py
	ldw	$12,$12,0
	stw	$12,$29,4		; store arg #1
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	ldw	$12,$12,0
	stw	$12,$29,8		; store arg #2
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	ldw	$12,$12,0
	stw	$12,$29,12		; store arg #3
	jal	plot
	add	$12,$25,0		; local var: i
	ldw	$12,$12,0
	add	$13,$0,1		; int literal: 1
	sub	$12,$12,$13
	stw	$12,$29,0		; store arg #0
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	stw	$12,$29,4		; store arg #1
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	stw	$12,$29,8		; store arg #2
	add	$12,$25,12		; local var: h
	ldw	$12,$12,0
	stw	$12,$29,12		; store arg #3
	add	$12,$25,16		; local var: px
	ldw	$12,$12,0
	stw	$12,$29,16		; store arg #4
	add	$12,$25,20		; local var: py
	ldw	$12,$12,0
	stw	$12,$29,20		; store arg #5
	jal	a
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	add	$13,$25,8		; local var: y
	ldw	$13,$13,0
	ldw	$13,$13,0
	add	$14,$0,2		; int literal: 2
	add	$15,$25,12		; local var: h
	ldw	$15,$15,0
	mul	$14,$14,$15
	add	$13,$13,$14
	stw	$13,$12,0		; assignment
	add	$12,$25,16		; local var: px
	ldw	$12,$12,0
	stw	$12,$29,0		; store arg #0
	add	$12,$25,20		; local var: py
	ldw	$12,$12,0
	stw	$12,$29,4		; store arg #1
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	ldw	$12,$12,0
	stw	$12,$29,8		; store arg #2
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	ldw	$12,$12,0
	stw	$12,$29,12		; store arg #3
	jal	plot
	add	$12,$25,0		; local var: i
	ldw	$12,$12,0
	add	$13,$0,1		; int literal: 1
	sub	$12,$12,$13
	stw	$12,$29,0		; store arg #0
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	stw	$12,$29,4		; store arg #1
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	stw	$12,$29,8		; store arg #2
	add	$12,$25,12		; local var: h
	ldw	$12,$12,0
	stw	$12,$29,12		; store arg #3
	add	$12,$25,16		; local var: px
	ldw	$12,$12,0
	stw	$12,$29,16		; store arg #4
	add	$12,$25,20		; local var: py
	ldw	$12,$12,0
	stw	$12,$29,20		; store arg #5
	jal	c
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	add	$13,$25,4		; local var: x
	ldw	$13,$13,0
	ldw	$13,$13,0
	add	$14,$25,12		; local var: h
	ldw	$14,$14,0
	sub	$13,$13,$14
	stw	$13,$12,0		; assignment
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	add	$13,$25,8		; local var: y
	ldw	$13,$13,0
	ldw	$13,$13,0
	add	$14,$25,12		; local var: h
	ldw	$14,$14,0
	add	$13,$13,$14
	stw	$13,$12,0		; assignment
	add	$12,$25,16		; local var: px
	ldw	$12,$12,0
	stw	$12,$29,0		; store arg #0
	add	$12,$25,20		; local var: py
	ldw	$12,$12,0
	stw	$12,$29,4		; store arg #1
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	ldw	$12,$12,0
	stw	$12,$29,8		; store arg #2
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	ldw	$12,$12,0
	stw	$12,$29,12		; store arg #3
	jal	plot
	add	$12,$25,0		; local var: i
	ldw	$12,$12,0
	add	$13,$0,1		; int literal: 1
	sub	$12,$12,$13
	stw	$12,$29,0		; store arg #0
	add	$12,$25,4		; local var: x
	ldw	$12,$12,0
	stw	$12,$29,4		; store arg #1
	add	$12,$25,8		; local var: y
	ldw	$12,$12,0
	stw	$12,$29,8		; store arg #2
	add	$12,$25,12		; local var: h
	ldw	$12,$12,0
	stw	$12,$29,12		; store arg #3
	add	$12,$25,16		; local var: px
	ldw	$12,$12,0
	stw	$12,$29,16		; store arg #4
	add	$12,$25,20		; local var: py
	ldw	$12,$12,0
	stw	$12,$29,20		; store arg #5
	jal	d
L7:
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,28		; restore old frame pointer
	add	$29,$29,32		; release frame
	jr	$31			; return

	.export	main
main:
	sub	$29,$29,68		; allocate frame
	stw	$25,$29,28		; save old frame pointer
	add	$25,$29,68		; setup new frame pointer
	stw	$31,$25,-44		; save return register
	add	$12,$25,-36		; local var: beige
	add	$13,$0,245		; int literal: 245
	add	$14,$0,65536		; int literal: 65536
	mul	$13,$13,$14
	add	$14,$0,245		; int literal: 245
	add	$15,$0,256		; int literal: 256
	mul	$14,$14,$15
	add	$13,$13,$14
	add	$14,$0,220		; int literal: 220
	add	$13,$13,$14
	stw	$13,$12,0		; assignment
	add	$12,$25,-36		; local var: beige
	ldw	$12,$12,0
	stw	$12,$29,0		; store arg #0
	jal	clearAll
	add	$12,$25,-16		; local var: i
	add	$13,$0,0		; int literal: 0
	stw	$13,$12,0		; assignment
	add	$12,$25,-12		; local var: h
	add	$13,$0,256		; int literal: 256
	add	$14,$0,4		; int literal: 4
	div	$13,$13,$14
	stw	$13,$12,0		; assignment
	add	$12,$25,-20		; local var: x0
	add	$13,$0,2		; int literal: 2
	add	$14,$25,-12		; local var: h
	ldw	$14,$14,0
	mul	$13,$13,$14
	stw	$13,$12,0		; assignment
	add	$12,$25,-24		; local var: y0
	add	$13,$0,3		; int literal: 3
	add	$14,$25,-12		; local var: h
	ldw	$14,$14,0
	mul	$13,$13,$14
	stw	$13,$12,0		; assignment
L8:
	add	$12,$25,-16		; local var: i
	ldw	$12,$12,0
	add	$13,$0,4		; int literal: 4
	bne	$12,$13,L9
	j	L10
L9:
	add	$13,$25,-16		; local var: i
	add	$14,$25,-16		; local var: i
	ldw	$14,$14,0
	add	$15,$0,1		; int literal: 1
	add	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-20		; local var: x0
	add	$14,$25,-20		; local var: x0
	ldw	$14,$14,0
	add	$15,$25,-12		; local var: h
	ldw	$15,$15,0
	sub	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-12		; local var: h
	add	$14,$25,-12		; local var: h
	ldw	$14,$14,0
	add	$15,$0,2		; int literal: 2
	div	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-24		; local var: y0
	add	$14,$25,-24		; local var: y0
	ldw	$14,$14,0
	add	$15,$25,-12		; local var: h
	ldw	$15,$15,0
	add	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-4		; local var: x
	add	$14,$25,-20		; local var: x0
	ldw	$14,$14,0
	stw	$14,$13,0		; assignment
	add	$13,$25,-8		; local var: y
	add	$14,$25,-24		; local var: y0
	ldw	$14,$14,0
	stw	$14,$13,0		; assignment
	add	$13,$25,-28		; local var: px
	add	$14,$25,-4		; local var: x
	ldw	$14,$14,0
	stw	$14,$13,0		; assignment
	add	$13,$25,-32		; local var: py
	add	$14,$25,-8		; local var: y
	ldw	$14,$14,0
	stw	$14,$13,0		; assignment
	add	$13,$25,-16		; local var: i
	ldw	$13,$13,0
	stw	$13,$29,0		; store arg #0
	add	$13,$25,-4		; local var: x
	stw	$13,$29,4		; store arg #1
	add	$13,$25,-8		; local var: y
	stw	$13,$29,8		; store arg #2
	add	$13,$25,-12		; local var: h
	ldw	$13,$13,0
	stw	$13,$29,12		; store arg #3
	add	$13,$25,-28		; local var: px
	stw	$13,$29,16		; store arg #4
	add	$13,$25,-32		; local var: py
	stw	$13,$29,20		; store arg #5
	jal	a
	add	$13,$25,-4		; local var: x
	add	$14,$25,-4		; local var: x
	ldw	$14,$14,0
	add	$15,$25,-12		; local var: h
	ldw	$15,$15,0
	add	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-8		; local var: y
	add	$14,$25,-8		; local var: y
	ldw	$14,$14,0
	add	$15,$25,-12		; local var: h
	ldw	$15,$15,0
	sub	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-28		; local var: px
	stw	$13,$29,0		; store arg #0
	add	$13,$25,-32		; local var: py
	stw	$13,$29,4		; store arg #1
	add	$13,$25,-4		; local var: x
	ldw	$13,$13,0
	stw	$13,$29,8		; store arg #2
	add	$13,$25,-8		; local var: y
	ldw	$13,$13,0
	stw	$13,$29,12		; store arg #3
	jal	plot
	add	$13,$25,-16		; local var: i
	ldw	$13,$13,0
	stw	$13,$29,0		; store arg #0
	add	$13,$25,-4		; local var: x
	stw	$13,$29,4		; store arg #1
	add	$13,$25,-8		; local var: y
	stw	$13,$29,8		; store arg #2
	add	$13,$25,-12		; local var: h
	ldw	$13,$13,0
	stw	$13,$29,12		; store arg #3
	add	$13,$25,-28		; local var: px
	stw	$13,$29,16		; store arg #4
	add	$13,$25,-32		; local var: py
	stw	$13,$29,20		; store arg #5
	jal	b
	add	$13,$25,-4		; local var: x
	add	$14,$25,-4		; local var: x
	ldw	$14,$14,0
	add	$15,$25,-12		; local var: h
	ldw	$15,$15,0
	sub	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-8		; local var: y
	add	$14,$25,-8		; local var: y
	ldw	$14,$14,0
	add	$15,$25,-12		; local var: h
	ldw	$15,$15,0
	sub	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-28		; local var: px
	stw	$13,$29,0		; store arg #0
	add	$13,$25,-32		; local var: py
	stw	$13,$29,4		; store arg #1
	add	$13,$25,-4		; local var: x
	ldw	$13,$13,0
	stw	$13,$29,8		; store arg #2
	add	$13,$25,-8		; local var: y
	ldw	$13,$13,0
	stw	$13,$29,12		; store arg #3
	jal	plot
	add	$13,$25,-16		; local var: i
	ldw	$13,$13,0
	stw	$13,$29,0		; store arg #0
	add	$13,$25,-4		; local var: x
	stw	$13,$29,4		; store arg #1
	add	$13,$25,-8		; local var: y
	stw	$13,$29,8		; store arg #2
	add	$13,$25,-12		; local var: h
	ldw	$13,$13,0
	stw	$13,$29,12		; store arg #3
	add	$13,$25,-28		; local var: px
	stw	$13,$29,16		; store arg #4
	add	$13,$25,-32		; local var: py
	stw	$13,$29,20		; store arg #5
	jal	c
	add	$13,$25,-4		; local var: x
	add	$14,$25,-4		; local var: x
	ldw	$14,$14,0
	add	$15,$25,-12		; local var: h
	ldw	$15,$15,0
	sub	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-8		; local var: y
	add	$14,$25,-8		; local var: y
	ldw	$14,$14,0
	add	$15,$25,-12		; local var: h
	ldw	$15,$15,0
	add	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-28		; local var: px
	stw	$13,$29,0		; store arg #0
	add	$13,$25,-32		; local var: py
	stw	$13,$29,4		; store arg #1
	add	$13,$25,-4		; local var: x
	ldw	$13,$13,0
	stw	$13,$29,8		; store arg #2
	add	$13,$25,-8		; local var: y
	ldw	$13,$13,0
	stw	$13,$29,12		; store arg #3
	jal	plot
	add	$13,$25,-16		; local var: i
	ldw	$13,$13,0
	stw	$13,$29,0		; store arg #0
	add	$13,$25,-4		; local var: x
	stw	$13,$29,4		; store arg #1
	add	$13,$25,-8		; local var: y
	stw	$13,$29,8		; store arg #2
	add	$13,$25,-12		; local var: h
	ldw	$13,$13,0
	stw	$13,$29,12		; store arg #3
	add	$13,$25,-28		; local var: px
	stw	$13,$29,16		; store arg #4
	add	$13,$25,-32		; local var: py
	stw	$13,$29,20		; store arg #5
	jal	d
	add	$13,$25,-4		; local var: x
	add	$14,$25,-4		; local var: x
	ldw	$14,$14,0
	add	$15,$25,-12		; local var: h
	ldw	$15,$15,0
	add	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-8		; local var: y
	add	$14,$25,-8		; local var: y
	ldw	$14,$14,0
	add	$15,$25,-12		; local var: h
	ldw	$15,$15,0
	add	$14,$14,$15
	stw	$14,$13,0		; assignment
	add	$13,$25,-28		; local var: px
	stw	$13,$29,0		; store arg #0
	add	$13,$25,-32		; local var: py
	stw	$13,$29,4		; store arg #1
	add	$13,$25,-4		; local var: x
	ldw	$13,$13,0
	stw	$13,$29,8		; store arg #2
	add	$13,$25,-8		; local var: y
	ldw	$13,$13,0
	stw	$13,$29,12		; store arg #3
	jal	plot
	j	L8
L10:
	ldw	$31,$25,-44		; restore return register
	ldw	$25,$29,28		; restore old frame pointer
	add	$29,$29,68		; release frame
	jr	$31			; return
