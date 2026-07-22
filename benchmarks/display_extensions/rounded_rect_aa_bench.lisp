(sdl-init)

(define win (sdl-create-window "ounded rectangle AA benchmark" 256 128))
(define rend (sdl-create-soft-renderer win))

(defun event-loop (w)
  (let ((event (sdl-poll-event)))
    (if (eq event 'sdl-quit-event)
        (custom-destruct w)
        (progn
          (yield 5000)
          (event-loop w)))))

(spawn 100 event-loop win)
(sdl-set-active-renderer rend)

(define img256x128 (img-buffer 'rgb888 256 128))
(img-clear img256x128 0x080D18)

(define blue  (img-color 'regular 0x3EA9F5))
(define mint  (img-color 'regular 0x50E3C2))
(define amber (img-color 'regular 0xFFC864))
(define iterations 20000)

(defun bench-filled (aa)
  (let ((t0 (systime))) {
    (loopfor i 0 (< i iterations) (+ i 1) {
      (img-rectangle img256x128 22 18 190 76 blue
                     '(rounded 30) '(filled) (list 'aa aa))
    })
    (- (systime) t0)}) )

(defun bench-thin-outline (aa)
  (let ((t0 (systime))) {
    (loopfor i 0 (< i iterations) (+ i 1) {
      (img-rectangle img256x128 22 18 190 76 mint
                     '(rounded 30) '(thickness 3) (list 'aa aa))
    })
    (- (systime) t0)}) )

(defun bench-thick-outline (aa)
  (let ((t0 (systime))) {
    (loopfor i 0 (< i iterations) (+ i 1) {
      (img-rectangle img256x128 22 18 190 76 amber
                     '(rounded 30) '(thickness 14) (list 'aa aa))
    })
    (- (systime) t0)}) )

(define filled-hard  (bench-filled 0))
(define filled-aa    (bench-filled 1))
(define thin-hard    (bench-thin-outline 0))
(define thin-aa      (bench-thin-outline 1))
(define thick-hard   (bench-thick-outline 0))
(define thick-aa     (bench-thick-outline 1))

(img-clear img256x128 0x080D18)
(img-rectangle img256x128 22 18 190 76 amber '(rounded 30) '(thickness 14) '(aa 1))
(disp-render img256x128 0 0)

(print "ROUNDED_BENCH iterations=" iterations)
(print "filled hard=" filled-hard " aa=" filled-aa)
(print "thin hard=" thin-hard " aa=" thin-aa)
(print "thick hard=" thick-hard " aa=" thick-aa)

(if (and (> filled-hard 0) (> filled-aa 0)
         (> thin-hard 0) (> thin-aa 0)
         (> thick-hard 0) (> thick-aa 0))
    (print "SUCCESS")
    (print "FAILURE"))
