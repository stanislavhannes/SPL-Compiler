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
	.export	p
	sub	$29,$29,20		; allocate frame
	stw	$25,$29,8		; save old frame pointer
	add	$25,$29,20		; setup new frame pointer
	stw	$31,$25,-16		; save return register
	.export	main
	sub	$29,$29,20		; allocate frame
	stw	$25,$29,12		; save old frame pointer
	add	$25,$29,20		; setup new frame pointer
	stw	$31,$25,-12		; save return register
