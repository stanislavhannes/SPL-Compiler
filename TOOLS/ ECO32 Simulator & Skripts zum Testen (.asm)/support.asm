;
; support.asm -- SPL runtime support
;

	.import	main

	.export	printi
	.export	printc
	.export	readi
	.export	readc
	.export	exit
	.export	time
	.export	clearAll
	.export	setPixel
	.export	drawLine
	.export	drawCircle
	.export	_indexError

	.set	tmr,0xF0000000		; timer base address
	.set	trm,0xF0300000		; terminal base address
	.set	grf,0xFFC00000		; graphics base address

; **************************************************************

;
; startup routine & common interrupt handler
;

	.code
	.align	4

	; reset arrives here
reset:
	j	start

	; interrupts arrive here
intrpt:
	sub	$29,$29,20*4		; 20 registers to save
	stw	$1,$29,0		; save registers
	stw	$2,$29,4
	stw	$8,$29,8
	stw	$9,$29,12
	stw	$10,$29,16
	stw	$11,$29,20
	stw	$12,$29,24
	stw	$13,$29,28
	stw	$14,$29,32
	stw	$15,$29,36
	stw	$16,$29,40
	stw	$17,$29,44
	stw	$18,$29,48
	stw	$19,$29,52
	stw	$20,$29,56
	stw	$21,$29,60
	stw	$22,$29,64
	stw	$23,$29,68
	stw	$25,$29,72
	stw	$31,$29,76
	add	$25,$29,0		; fp = sp
	mvfs	$26,0			; get PSW
	slr	$26,$26,14		; $26 = 4 * IRQ number
	and	$26,$26,0x1F << 2
	ldw	$27,$26,irqsrv		; get addr of service routine
	jalr	$27			; call service routine
	ldw	$1,$29,0		; restore registers
	ldw	$2,$29,4
	ldw	$8,$29,8
	ldw	$9,$29,12
	ldw	$10,$29,16
	ldw	$11,$29,20
	ldw	$12,$29,24
	ldw	$13,$29,28
	ldw	$14,$29,32
	ldw	$15,$29,36
	ldw	$16,$29,40
	ldw	$17,$29,44
	ldw	$18,$29,48
	ldw	$19,$29,52
	ldw	$20,$29,56
	ldw	$21,$29,60
	ldw	$22,$29,64
	ldw	$23,$29,68
	ldw	$25,$29,72
	ldw	$31,$29,76
	add	$29,$29,20*4		; release save area
	rfx				; return from interrupt

	; initialize runtime support and call main, then halt
start:
	add	$8,$0,1 << 27		; set V-bit in PSW
	mvts	$8,0
	add	$25,$0,0xC0100000	; stack is located 1M above code
	sub	$29,$25,4		; sp = fp - 4
	jal	tmrinit			; initialize timer
	jal	grinit			; initialize graphics
	add	$8,$0,startmsg
	stw	$8,$29,0
	jal	msgout			; say that main is going to execute
	jal	main
over:
	add	$8,$0,stopmsg
	stw	$8,$29,0
	jal	msgout			; say that main is over
stop:
	j	stop			; loop forever

startmsg:
	.byte	"SPL/RTS: main() started", 0x0d, 0x0a, 0

stopmsg:
	.byte	"SPL/RTS: main() finished", 0x0d, 0x0a, 0

; **************************************************************

;
; standard library
;

	.code
	.align	4

	; printi(i: int)
printi:
	sub	$29,$29,16
	stw	$25,$29,8
	add	$25,$29,16
	stw	$31,$25,-12
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,0
	bge	$8,$9,printi1
	add	$8,$0,45
	stw	$8,$29,0
	jal	printc
	add	$8,$25,0
	add	$9,$0,0
	add	$10,$25,0
	ldw	$10,$10,0
	sub	$9,$9,$10
	stw	$9,$8,0
printi1:
	add	$8,$25,-4
	add	$9,$25,0
	ldw	$9,$9,0
	add	$10,$0,10
	div	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,0
	beq	$8,$9,printi2
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0
	jal	printi
printi2:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,10
	mul	$9,$9,$10
	sub	$8,$8,$9
	add	$9,$0,48
	add	$8,$8,$9
	stw	$8,$29,0
	jal	printc
	ldw	$31,$25,-12
	ldw	$25,$29,8
	add	$29,$29,16
	jr	$31

	; printc(i: int)
printc:
	add	$8,$0,trm		; set terminal base address
	ldw	$10,$29,0		; get char
	add	$9,$0,0x0A		; line feed?
	bne	$10,$9,printc1		; no - output as is
printc0:				; else output cr first
	ldw	$9,$8,8			; get status
	and	$9,$9,1			; xmtr ready?
	beq	$9,$0,printc0		; no - wait
	add	$10,$0,0x0D
	stw	$10,$8,12		; send char
printc1:
	ldw	$9,$8,8			; get status
	and	$9,$9,1			; xmtr ready?
	beq	$9,$0,printc1		; no - wait
	ldw	$10,$29,0		; get char
	stw	$10,$8,12		; send char
	jr	$31			; return

;***************************************************************

readLine:
	sub	$29,$29,20
	stw	$25,$29,8
	add	$25,$29,20
	stw	$31,$25,-16
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
readLine0:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,79
	bge	$8,$9,readLine1
	add	$8,$25,-8
	stw	$8,$29,0
	jal	readc
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$0,32
	blt	$8,$9,readLine2
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,0
	jal	printc
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,-8
	ldw	$9,$9,0
	stw	$9,$8,0
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	readLine3
readLine2:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$0,13
	bne	$8,$9,readLine4
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,0
	jal	printc
	add	$8,$0,10
	stw	$8,$29,0
	jal	printc
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-4
	add	$9,$0,79
	stw	$9,$8,0
	j	readLine5
readLine4:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$0,8
	bne	$8,$9,readLine6
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,0
	ble	$8,$9,readLine7
	add	$8,$0,8
	stw	$8,$29,0
	jal	printc
	add	$8,$0,32
	stw	$8,$29,0
	jal	printc
	add	$8,$0,8
	stw	$8,$29,0
	jal	printc
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
readLine7:
readLine6:
readLine5:
readLine3:
	j	readLine0
readLine1:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,79
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	ldw	$31,$25,-16
	ldw	$25,$29,8
	add	$29,$29,20
	jr	$31

readInt:
	sub	$29,$29,20
	stw	$25,$29,8
	add	$25,$29,20
	stw	$31,$25,-16
	add	$8,$25,-4
	add	$9,$0,1
	stw	$9,$8,0
readInt8:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,1
	bne	$8,$9,readInt9
readInt10:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,32
	bne	$8,$9,readInt11
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	readInt10
readInt11:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,0
	bne	$8,$9,readInt12
	add	$8,$25,0
	ldw	$8,$8,0
	stw	$8,$29,0
	jal	readLine
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$0,0
	stw	$9,$8,0
	j	readInt13
readInt12:
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
readInt13:
	j	readInt8
readInt9:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,45
	bne	$8,$9,readInt14
	add	$8,$25,-8
	add	$9,$0,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	readInt15
readInt14:
	add	$8,$25,-8
	add	$9,$0,1
	stw	$9,$8,0
readInt15:
	add	$8,$25,8
	ldw	$8,$8,0
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-4
	add	$9,$0,1
	stw	$9,$8,0
readInt16:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,1
	bne	$8,$9,readInt17
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,48
	blt	$8,$9,readInt18
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,57
	bgt	$8,$9,readInt20
	add	$8,$25,8
	ldw	$8,$8,0
	add	$9,$25,8
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,10
	mul	$9,$9,$10
	add	$10,$25,0
	ldw	$10,$10,0
	add	$11,$25,4
	ldw	$11,$11,0
	ldw	$11,$11,0
	mul	$11,$11,4
	add	$10,$10,$11
	ldw	$10,$10,0
	add	$9,$9,$10
	add	$10,$0,48
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	readInt21
readInt20:
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
readInt21:
	j	readInt19
readInt18:
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
readInt19:
	j	readInt16
readInt17:
	add	$8,$25,8
	ldw	$8,$8,0
	add	$9,$25,8
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$25,-8
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
	ldw	$31,$25,-16
	ldw	$25,$29,8
	add	$29,$29,20
	jr	$31

	; readi(ref i: int)
readi:
	sub	$29,$29,20
	stw	$25,$29,16
	add	$25,$29,20
	stw	$31,$25,-8
	add	$8,$0,line
	stw	$8,$29,0
	add	$8,$0,ptr
	stw	$8,$29,4
	ldw	$8,$25,0
	stw	$8,$29,8
	jal	readInt
	ldw	$31,$25,-8
	ldw	$25,$29,16
	add	$29,$29,20
	jr	$31

line:
	.space	80*4

ptr:
	.word	0

;***************************************************************

	; readc(ref i: int)
readc:
	add	$8,$0,trm		; set terminal base address
readc1:
	ldw	$9,$8,0			; get status
	and	$9,$9,1			; rcvr ready?
	beq	$9,$0,readc1		; no - wait
	ldw	$10,$8,4		; get char
	ldw	$11,$29,0		; get address
	stw	$10,$11,0		; store char
	jr	$31			; return

	; exit()
exit:
	j	over

	; time(ref i: int)
time:
	ldw	$8,$29,0		; get address
	ldw	$9,$0,seconds		; get time
	stw	$9,$8,0			; store time
	jr	$31

tmrinit:
	add	$8,$0,irqsrv		; set ISR
	add	$9,$0,update
	stw	$9,$8,4*14
	add	$8,$0,tmr		; program timer
	add	$9,$0,1000		; divisor = 1000
	stw	$9,$8,4
	add	$9,$0,2			; enable timer interrupts
	stw	$9,$8,0
	mvfs	$8,0
	or	$8,$8,1 << 14		; open timer IRQ mask bit
	or	$8,$8,1 << 23		; enable processor interrupts
	mvts	$8,0
	jr	$31

update:
	add	$8,$0,2			; reset timer IRQ
	stw	$8,$0,tmr
	ldw	$8,$0,seconds
	add	$8,$8,1
	stw	$8,$0,seconds
	jr	$31

seconds:
	.word	0

; **************************************************************

;
; graphics library
;

	.code
	.align	4

grInstalled:
	.word	1

noGrMsg:
	.byte	"SPL/RTS: graphics controller not installed"
	.byte	0x0D, 0x0A, 0

	.code
	.align	4

grintrpt:
	stw	$0,$0,grInstalled	; interrupt - no graphics
	add	$30,$30,4		; skip offending instruction
	jr	$31

grinit:
	add	$8,$0,irqsrv
	ldw	$9,$8,4*16		; get old ISR for bus timeout
	add	$10,$0,grintrpt
	stw	$10,$8,4*16		; install new ISR
	stw	$0,$0,grf		; try to access frame buffer
	stw	$9,$8,4*16		; restore old ISR
	jr	$31

noGraphics:
	sub	$29,$29,12
	stw	$25,$29,8
	add	$25,$29,12
	stw	$31,$25,-8
	add	$8,$0,noGrMsg
	stw	$8,$29,0
	jal	msgout
	ldw	$31,$25,-8
	ldw	$25,$29,8
	add	$29,$29,12
	j	over

	; clearAll(color: int)
clearAll:
	ldw	$8,$0,grInstalled
	beq	$8,$0,noGraphics
clearAllNoCheck:
	add	$8,$0,grf
	add	$9,$0,640*480
	ldw	$10,$29,0
clearAll1:
	stw	$10,$8,0
	add	$8,$8,4
	sub	$9,$9,1
	bne	$9,$0,clearAll1
	jr	$31

	; setPixel(x: int, y: int, color: int)
setPixel:
	ldw	$8,$0,grInstalled
	beq	$8,$0,noGraphics
setPixelNoCheck:
	sub	$29,$29,4
	stw	$25,$29,0
	add	$25,$29,4
	add	$8,$0,grf
	add	$9,$0,640
	add	$10,$25,4
	ldw	$10,$10,0
	mul	$9,$9,$10
	add	$10,$25,0
	ldw	$10,$10,0
	add	$9,$9,$10
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,8
	ldw	$9,$9,0
	stw	$9,$8,0
	ldw	$25,$29,0
	add	$29,$29,4
	jr	$31

	; drawLine(x1: int, y1: int, x2: int, y2: int, color: int)
drawLine:
	ldw	$8,$0,grInstalled
	beq	$8,$0,noGraphics
drawLineNoCheck:
	sub	$29,$29,48
	stw	$25,$29,16
	add	$25,$29,48
	stw	$31,$25,-36
	add	$8,$25,-4
	add	$9,$25,0
	ldw	$9,$9,0
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$25,4
	ldw	$9,$9,0
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4
	add	$8,$25,16
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,-12
	add	$9,$25,8
	ldw	$9,$9,0
	add	$10,$25,0
	ldw	$10,$10,0
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-16
	add	$9,$25,12
	ldw	$9,$9,0
	add	$10,$25,4
	ldw	$10,$10,0
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-12
	ldw	$8,$8,0
	add	$9,$0,0
	bge	$8,$9,drawLine0
	add	$8,$25,-16
	ldw	$8,$8,0
	add	$9,$0,0
	bge	$8,$9,drawLine2
	add	$8,$0,0
	add	$9,$25,-12
	ldw	$9,$9,0
	sub	$8,$8,$9
	add	$9,$0,0
	add	$10,$25,-16
	ldw	$10,$10,0
	sub	$9,$9,$10
	bge	$8,$9,drawLine4
	add	$8,$25,-20
	add	$9,$0,0
	add	$10,$25,-16
	ldw	$10,$10,0
	sub	$9,$9,$10
	add	$10,$0,2
	add	$11,$25,-12
	ldw	$11,$11,0
	mul	$10,$10,$11
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-24
	add	$9,$0,0
	add	$10,$0,2
	sub	$9,$9,$10
	add	$10,$25,-16
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-28
	add	$9,$0,2
	add	$10,$25,-12
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
drawLine6:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$25,12
	ldw	$9,$9,0
	ble	$8,$9,drawLine7
	add	$8,$25,-20
	ldw	$8,$8,0
	add	$9,$0,0
	bgt	$8,$9,drawLine8
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-24
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
drawLine8:
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-28
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4
	add	$8,$25,16
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	j	drawLine6
drawLine7:
	j	drawLine5
drawLine4:
	add	$8,$25,-20
	add	$9,$0,0
	add	$10,$25,-12
	ldw	$10,$10,0
	sub	$9,$9,$10
	add	$10,$0,2
	add	$11,$25,-16
	ldw	$11,$11,0
	mul	$10,$10,$11
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-24
	add	$9,$0,0
	add	$10,$0,2
	sub	$9,$9,$10
	add	$10,$25,-12
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-28
	add	$9,$0,2
	add	$10,$25,-16
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
drawLine9:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,8
	ldw	$9,$9,0
	ble	$8,$9,drawLine10
	add	$8,$25,-20
	ldw	$8,$8,0
	add	$9,$0,0
	bgt	$8,$9,drawLine11
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-24
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
drawLine11:
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-28
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4
	add	$8,$25,16
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	j	drawLine9
drawLine10:
drawLine5:
	j	drawLine3
drawLine2:
	add	$8,$0,0
	add	$9,$25,-12
	ldw	$9,$9,0
	sub	$8,$8,$9
	add	$9,$25,-16
	ldw	$9,$9,0
	bge	$8,$9,drawLine12
	add	$8,$25,-20
	add	$9,$25,-16
	ldw	$9,$9,0
	add	$10,$0,2
	add	$11,$25,-12
	ldw	$11,$11,0
	mul	$10,$10,$11
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-24
	add	$9,$0,2
	add	$10,$25,-16
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-28
	add	$9,$0,2
	add	$10,$25,-12
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
drawLine14:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$25,12
	ldw	$9,$9,0
	bge	$8,$9,drawLine15
	add	$8,$25,-20
	ldw	$8,$8,0
	add	$9,$0,0
	bge	$8,$9,drawLine16
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-24
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
drawLine16:
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-28
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4
	add	$8,$25,16
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	j	drawLine14
drawLine15:
	j	drawLine13
drawLine12:
	add	$8,$25,-20
	add	$9,$0,0
	add	$10,$25,-12
	ldw	$10,$10,0
	sub	$9,$9,$10
	add	$10,$0,2
	add	$11,$25,-16
	ldw	$11,$11,0
	mul	$10,$10,$11
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-24
	add	$9,$0,0
	add	$10,$0,2
	sub	$9,$9,$10
	add	$10,$25,-12
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-28
	add	$9,$0,0
	add	$10,$0,2
	sub	$9,$9,$10
	add	$10,$25,-16
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
drawLine17:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,8
	ldw	$9,$9,0
	ble	$8,$9,drawLine18
	add	$8,$25,-20
	ldw	$8,$8,0
	add	$9,$0,0
	bge	$8,$9,drawLine19
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-24
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
drawLine19:
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-28
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4
	add	$8,$25,16
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	j	drawLine17
drawLine18:
drawLine13:
drawLine3:
	j	drawLine1
drawLine0:
	add	$8,$25,-16
	ldw	$8,$8,0
	add	$9,$0,0
	bge	$8,$9,drawLine20
	add	$8,$25,-12
	ldw	$8,$8,0
	add	$9,$0,0
	add	$10,$25,-16
	ldw	$10,$10,0
	sub	$9,$9,$10
	bge	$8,$9,drawLine22
	add	$8,$25,-20
	add	$9,$0,0
	add	$10,$25,-16
	ldw	$10,$10,0
	sub	$9,$9,$10
	add	$10,$0,2
	add	$11,$25,-12
	ldw	$11,$11,0
	mul	$10,$10,$11
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-24
	add	$9,$0,0
	add	$10,$0,2
	sub	$9,$9,$10
	add	$10,$25,-16
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-28
	add	$9,$0,0
	add	$10,$0,2
	sub	$9,$9,$10
	add	$10,$25,-12
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
drawLine24:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$25,12
	ldw	$9,$9,0
	ble	$8,$9,drawLine25
	add	$8,$25,-20
	ldw	$8,$8,0
	add	$9,$0,0
	bgt	$8,$9,drawLine26
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-24
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
drawLine26:
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-28
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4
	add	$8,$25,16
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	j	drawLine24
drawLine25:
	j	drawLine23
drawLine22:
	add	$8,$25,-20
	add	$9,$25,-12
	ldw	$9,$9,0
	add	$10,$0,2
	add	$11,$25,-16
	ldw	$11,$11,0
	mul	$10,$10,$11
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-24
	add	$9,$0,2
	add	$10,$25,-12
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-28
	add	$9,$0,2
	add	$10,$25,-16
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
drawLine27:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,8
	ldw	$9,$9,0
	bge	$8,$9,drawLine28
	add	$8,$25,-20
	ldw	$8,$8,0
	add	$9,$0,0
	bgt	$8,$9,drawLine29
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-24
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
drawLine29:
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-28
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4
	add	$8,$25,16
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	j	drawLine27
drawLine28:
drawLine23:
	j	drawLine21
drawLine20:
	add	$8,$25,-12
	ldw	$8,$8,0
	add	$9,$25,-16
	ldw	$9,$9,0
	bge	$8,$9,drawLine30
	add	$8,$25,-20
	add	$9,$25,-16
	ldw	$9,$9,0
	add	$10,$0,2
	add	$11,$25,-12
	ldw	$11,$11,0
	mul	$10,$10,$11
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-24
	add	$9,$0,2
	add	$10,$25,-16
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-28
	add	$9,$0,0
	add	$10,$0,2
	sub	$9,$9,$10
	add	$10,$25,-12
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
drawLine32:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$25,12
	ldw	$9,$9,0
	bge	$8,$9,drawLine33
	add	$8,$25,-20
	ldw	$8,$8,0
	add	$9,$0,0
	bge	$8,$9,drawLine34
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-24
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
drawLine34:
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-28
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4
	add	$8,$25,16
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	j	drawLine32
drawLine33:
	j	drawLine31
drawLine30:
	add	$8,$25,-20
	add	$9,$25,-12
	ldw	$9,$9,0
	add	$10,$0,2
	add	$11,$25,-16
	ldw	$11,$11,0
	mul	$10,$10,$11
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-24
	add	$9,$0,2
	add	$10,$25,-12
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-28
	add	$9,$0,0
	add	$10,$0,2
	sub	$9,$9,$10
	add	$10,$25,-16
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
drawLine35:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,8
	ldw	$9,$9,0
	bge	$8,$9,drawLine36
	add	$8,$25,-20
	ldw	$8,$8,0
	add	$9,$0,0
	bge	$8,$9,drawLine37
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-24
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
drawLine37:
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$25,-28
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4
	add	$8,$25,16
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	j	drawLine35
drawLine36:
drawLine31:
drawLine21:
drawLine1:
	ldw	$31,$25,-36
	ldw	$25,$29,16
	add	$29,$29,48
	jr	$31

	; drawCircle(x0: int, y0: int, radius: int, color: int)
drawCircle:
	ldw	$8,$0,grInstalled
	beq	$8,$0,noGraphics
drawCircleNoCheck:
	sub	$29,$29,40
	stw	$25,$29,16
	add	$25,$29,40
	stw	$31,$25,-28
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$25,8
	ldw	$9,$9,0
	stw	$9,$8,0
	add	$8,$25,-12
	add	$9,$0,1
	add	$10,$25,8
	ldw	$10,$10,0
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-16
	add	$9,$0,3
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$0,0
	add	$10,$0,2
	sub	$9,$9,$10
	add	$10,$25,8
	ldw	$10,$10,0
	mul	$9,$9,$10
	add	$10,$0,5
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	beq	$8,$9,drawCircle0
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
drawCircle0:
drawCircle1:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	ble	$8,$9,drawCircle2
	add	$8,$25,-12
	ldw	$8,$8,0
	add	$9,$0,0
	bge	$8,$9,drawCircle3
	add	$8,$25,-12
	add	$9,$25,-12
	ldw	$9,$9,0
	add	$10,$25,-16
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-16
	add	$9,$25,-16
	ldw	$9,$9,0
	add	$10,$0,2
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$0,2
	add	$9,$9,$10
	stw	$9,$8,0
	j	drawCircle4
drawCircle3:
	add	$8,$25,-12
	add	$9,$25,-12
	ldw	$9,$9,0
	add	$10,$25,-20
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-16
	add	$9,$25,-16
	ldw	$9,$9,0
	add	$10,$0,2
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-20
	add	$9,$25,-20
	ldw	$9,$9,0
	add	$10,$0,4
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
drawCircle4:
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	beq	$8,$9,drawCircle5
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	sub	$8,$8,$9
	stw	$8,$29,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,4
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,8
	jal	setPixelNoCheck
drawCircle5:
	j	drawCircle1
drawCircle2:
	ldw	$31,$25,-28
	ldw	$25,$29,16
	add	$29,$29,40
	jr	$31

; **************************************************************

;
; runtime errors
;

	.code
	.align	4

_indexError:
	sub	$29,$29,12
	stw	$25,$29,8
	add	$25,$29,12
	stw	$31,$25,-8
	add	$8,$0,indexErrMsg
	stw	$8,$29,0
	jal	msgout
	ldw	$31,$25,-8
	ldw	$25,$29,8
	add	$29,$29,12
	j	over

indexErrMsg:
	.byte	"SPL/RTS: index out of bounds"
	.byte	0x0D, 0x0A, 0

; **************************************************************

;
; string output
;

	.code
	.align	4

msgout:
	sub	$29,$29,16
	stw	$25,$29,8
	add	$25,$29,16
	stw	$31,$25,-12
	ldw	$8,$25,0
	stw	$8,$25,-4
msgout1:
	ldw	$8,$25,-4
	ldbu	$9,$8,0
	beq	$9,$0,msgout2
	add	$8,$8,1
	stw	$8,$25,-4
	stw	$9,$29,0
	jal	printc
	j	msgout1
msgout2:
	ldw	$31,$25,-12
	ldw	$25,$29,8
	add	$29,$29,16
	jr	$31

; **************************************************************

;
; interrupt support
;

	.code
	.align	4

	; show message corresponding to interrupt
shmsg:
	sub	$29,$29,12
	stw	$25,$29,8
	add	$25,$29,12
	stw	$31,$25,-8
	ldw	$8,$26,msgtbl
	stw	$8,$29,0
	jal	msgout		; show message
	ldw	$31,$25,-8
	ldw	$25,$29,8
	add	$29,$29,12
	jr	$31

	; interrupt service routine table
irqsrv:	.word	shmsg		; 00: terminal 0 transmitter interrupt
	.word	shmsg		; 01: terminal 0 receiver interrupt
	.word	shmsg		; 02: terminal 1 transmitter interrupt
	.word	shmsg		; 03: terminal 1 receiver interrupt
	.word	shmsg		; 04: keyboard interrupt
	.word	shmsg		; 05: unused
	.word	shmsg		; 06: unused
	.word	shmsg		; 07: unused
	.word	shmsg		; 08: disk interrupt
	.word	shmsg		; 09: unused
	.word	shmsg		; 10: unused
	.word	shmsg		; 11: unused
	.word	shmsg		; 12: unused
	.word	shmsg		; 13: unused
	.word	shmsg		; 14: timer interrupt
	.word	shmsg		; 15: unused
	.word	shmsg		; 16: bus timeout exception
	.word	shmsg		; 17: illegal instruction exception
	.word	shmsg		; 18: privileged instruction exception
	.word	shmsg		; 19: divide instruction exception
	.word	shmsg		; 20: trap instruction exception
	.word	shmsg		; 21: TLB miss exception
	.word	shmsg		; 22: TLB write exception
	.word	shmsg		; 23: TLB invalid exception
	.word	shmsg		; 24: illegal address exception
	.word	shmsg		; 25: privileged address exception
	.word	shmsg		; 26: unused
	.word	shmsg		; 27: unused
	.word	shmsg		; 28: unused
	.word	shmsg		; 29: unused
	.word	shmsg		; 30: unused
	.word	shmsg		; 31: unused

	; message table
msgtbl:	.word	xmtmsg		; 00: terminal 0 transmitter interrupt
	.word	rcvmsg		; 01: terminal 0 receiver interrupt
	.word	xmtmsg		; 02: terminal 1 transmitter interrupt
	.word	rcvmsg		; 03: terminal 1 receiver interrupt
	.word	kbdmsg		; 04: keyboard interrupt
	.word	uimsg		; 05: unused
	.word	uimsg		; 06: unused
	.word	uimsg		; 07: unused
	.word	dskmsg		; 08: disk interrupt
	.word	uimsg		; 09: unused
	.word	uimsg		; 10: unused
	.word	uimsg		; 11: unused
	.word	uimsg		; 12: unused
	.word	uimsg		; 13: unused
	.word	uimsg		; 14: timer interrupt
	.word	uimsg		; 15: unused
	.word	btmsg		; 16: bus timeout exception
	.word	iimsg		; 17: illegal instruction exception
	.word	pimsg		; 18: privileged instruction exception
	.word	dimsg		; 19: divide instruction exception
	.word	timsg		; 20: trap instruction exception
	.word	msmsg		; 21: TLB miss exception
	.word	wrmsg		; 22: TLB write exception
	.word	ivmsg		; 23: TLB invalid exception
	.word	iamsg		; 24: illegal address exception
	.word	pamsg		; 25: privileged address exception
	.word	uemsg		; 26: unused
	.word	uemsg		; 27: unused
	.word	uemsg		; 28: unused
	.word	uemsg		; 29: unused
	.word	uemsg		; 30: unused
	.word	uemsg		; 31: unused

;
; interrupt messages
;

uimsg:	.byte	"SPL/RTS: unknown interrupt"
	.byte	0x0D, 0x0A, 0

xmtmsg:	.byte	"SPL/RTS: terminal transmitter interrupt"
	.byte	0x0D, 0x0A, 0

rcvmsg:	.byte	"SPL/RTS: terminal receiver interrupt"
	.byte	0x0D, 0x0A, 0

kbdmsg:	.byte	"SPL/RTS: keyboard interrupt"
	.byte	0x0D, 0x0A, 0

dskmsg:	.byte	"SPL/RTS: disk interrupt"
	.byte	0x0D, 0x0A, 0

tmrmsg:	.byte	"SPL/RTS: timer interrupt"
	.byte	0x0D, 0x0A, 0

;
; exception messages
;

uemsg:	.byte	"SPL/RTS: unknown exception"
	.byte	0x0D, 0x0A, 0

btmsg:	.byte	"SPL/RTS: bus timeout exception"
	.byte	0x0D, 0x0A, 0

iimsg:	.byte	"SPL/RTS: illegal instruction exception"
	.byte	0x0D, 0x0A, 0

pimsg:	.byte	"SPL/RTS: privileged instruction exception"
	.byte	0x0D, 0x0A, 0

dimsg:	.byte	"SPL/RTS: divide instruction exception"
	.byte	0x0D, 0x0A, 0

timsg:	.byte	"SPL/RTS: trap instruction exception"
	.byte	0x0D, 0x0A, 0

msmsg:	.byte	"SPL/RTS: TLB miss exception"
	.byte	0x0D, 0x0A, 0

wrmsg:	.byte	"SPL/RTS: TLB write exception"
	.byte	0x0D, 0x0A, 0

ivmsg:	.byte	"SPL/RTS: TLB invalid exception"
	.byte	0x0D, 0x0A, 0

iamsg:	.byte	"SPL/RTS: illegal address exception"
	.byte	0x0D, 0x0A, 0

pamsg:	.byte	"SPL/RTS: privileged address exception"
	.byte	0x0D, 0x0A, 0
