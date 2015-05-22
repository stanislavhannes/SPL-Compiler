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
	stw	$25,$29,0		; save old frame pointer
	add	$25,$29,16		; setup new frame pointer

	//Var
	add	$8,$25,-8

	//index
	add	$9,$0,0

	//arrayvar   
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9  -> speichert offset in Var

//intexp
	add	$9,$0,10

	//assignstm
	stw	$9,$8,0 //speicher Wert von $9 in $8 <- Var

	-------- a := VarA2[0]; -----
	//a
	add	$8,$25,-12

	//VarA2
	add	$9,$25,-8

	//Index
	add	$10,$0,0

	//array localisierung
	add	$11,$0,2
	bgeu	$10,$11,_indexError
	mul	$10,$10,4
	add	$9,$9,$10

	ldw	$9,$9,0

	//zuweisung von vara2 zu a
	stw	$9,$8,0

	ldw	$25,$29,0		; restore old frame pointer
	add	$29,$29,16		; release frame
	jr	$31			; return
