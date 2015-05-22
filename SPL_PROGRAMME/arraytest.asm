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
	sub	$29,$29,12		; allocate frame
	stw	$25,$29,0		; save old frame pointer
	add	$25,$29,12		; setup new frame pointer
	add	$8,$25,-8  // Position auf fp von varar2
	add	$9,$0,0   // Index von VarA2
	add	$10,$0,2  // Speicherfelder im Array
	bgeu	$9,$10,_indexError
	mul	$9,$9,4  // pos im array = multipliziere index mit größe von typ (int)
	add	$8,$8,$9  // addiere auf position von varar2 um position im array zu ermitteln
	add	$9,$0,10
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$0,1
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,20
	stw	$9,$8,0
	ldw	$25,$29,0		; restore old frame pointer
	add	$29,$29,12		; release frame
	jr	$31			; return
