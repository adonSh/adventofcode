(use-modules (ice-9 rdelim))

(define (get-directions)
  (let loop ((ds '())
             (l (read-line)))
    (if (eof-object? l)
      (map (lambda (d) (list (car d) (string->number (cadr d)))) (reverse ds))
      (loop (cons (string-tokenize l) ds) (read-line)))))

(define (calculate-final-position directions start)
  (if (null? directions)
    start
    (let ((d (car (car directions)))
          (n (cadr (car directions))))
      (cond
        ((equal? d "forward")
          (calculate-final-position (cdr directions)
                                    (cons (+ n (car start)) (cdr start))))
        ((equal? d "down")
          (calculate-final-position (cdr directions)
                                    (list (car start) (+ n (cadr start)))))
        ((equal? d "up")
          (calculate-final-position (cdr directions)
                                    (list (car start) (- (cadr start) n))))))))

(define (main)
  (let* ((directions (get-directions))
         (pos (calculate-final-position directions '(0 0))))
    (display (* (car pos) (cadr pos))) (newline)
    (display "P2") (newline)))

(main)
