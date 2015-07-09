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
	sub	$29,$29,16		; allocate frame
	stw	$25,$29,8		; save old frame pointer
	add	$25,$29,16		; setup new frame pointer
	stw	$31,$25,-12		; save return register
	add	$8,$25,-4
	add	$9,$0,2
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store arg #0
	jal	test
	ldw	$31,$25,-12		; restore return register
	ldw	$25,$29,8		; restore old frame pointer
	add	$29,$29,16		; release frame
	jr	$31			; return

	.export	test
test:
	sub	$29,$29,4		; allocate frame
	stw	$25,$29,0		; save old frame pointer
	add	$25,$29,4		; setup new frame pointer
	add	$8,$25,0
	add	$9,$0,1
	stw	$9,$8,0
	ldw	$25,$29,0		; restore old frame pointer
	add	$29,$29,4		; release frame
	jr	$31			; return
