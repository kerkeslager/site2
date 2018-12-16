(define-module (dk svg)
  #:use-module (sxml simple)
  #:export (embed-svg))

(define (string-starts-with? s subs)
  (let ((subs-length (string-length subs)))
    (if (< (string-length s) subs-length)
        #f
        (equal? (substring s 0 subs-length) subs))))

(define (strip-processing-instructions svg-nodes)
  (filter
    (lambda (svg-node)
      (if (pair? svg-node)
          (not (eqv? (car svg-node) '*PI*))
          #t))
    svg-nodes))

(define (clean-svg svg-node)
  (if (pair? svg-node)
      (let ((tag (car svg-node))
            (dtd "http://www.w3.org/2000/svg:"))
        (cond ((eqv? tag '*TOP*) (map clean-svg (strip-processing-instructions (cdr svg-node))))
              ((eqv? tag '@) svg-node)
              ((string-starts-with? (symbol->string tag) dtd)
               (cons (string->symbol (substring (symbol->string tag) (string-length dtd)))
                     (map clean-svg (cdr svg-node))))
              (else svg-node)))
      svg-node))

(define (embed-svg name)
  (clean-svg (call-with-input-file (string-append "svg/" name) xml->sxml)))
