(use-modules (ice-9 rdelim))

(define (get-ns)
  (let loop ((ns '())
            (l (read-line)))
    (if (eof-object? l)
      (reverse ns)
      (loop (cons (string->number l) ns) (read-line)))))

(define (count-increases ns)
  (let loop ((n 0) (nss ns))
    (cond
      ((null? nss) n)
      ((null? (cdr nss)) n)
      (else (if (< 0 (- (cadr nss) (car nss)))
        (loop (+ 1 n) (cdr nss))
        (loop n (cdr nss)))))))

(define (count-windows ns)
  (let loop ((count 0) (nss ns))
    (cond
      ((null? nss) count)
      ((null? (cdr nss)) count)
      ((null? (cddr nss)) count)
      ((null? (cdddr nss)) count)
      (else
        (let ((n1 (+ (car nss) (cadr nss) (caddr nss)))
              (n2 (+ (cadr nss) (caddr nss) (cadddr nss))))
          (if (> n2 n1)
            (loop (+ count 1) (cdr nss))
            (loop count (cdr nss))))))))

(define (main)
  (let ((ns (get-ns)))
    (display (count-increases ns)) (newline)
    (display (count-windows ns)) (newline)))

(main)
