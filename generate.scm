#!/usr/local/bin/guile -e main -s
!#

(define (dir-join . args)
  (if (null? (cdr args))
      (car args)
      (string-append (car args) file-name-separator-string (apply dir-join (cdr args)))))

(define (call-with-input-dir path proc)
  (let*
    ((dir (opendir path))
     (result (proc dir)))
    (closedir dir)
    result))

(define (dir->list dir)
  (let
    ((entry (readdir dir)))
    (if (eof-object? entry)
        '()
        (cons entry (dir->list dir)))))

(define (path->list path)
  (call-with-input-dir path dir->list))

(define (flatten xss)
  (if (null? xss)
      '()
      (append (car xss) (flatten (cdr xss)))))

(define (fs-find path)
  (cond ((equal? "." (basename path)) '())
        ((equal? ".." (basename path)) '())
        ((eq? (stat:type (stat path)) 'regular) (cons path '()))
        ((eq? (stat:type (stat path)) 'directory)
         (flatten (map (lambda (p) (fs-find (dir-join path p))) (path->list path))))))

#! TODO This doesn't actually check if the paths start with base-dir at all !#
(define (generate-target-filename path source-path target-path)
  (let* ((source-path-length (string-length source-path))
         (path-remainder (string-drop path source-path-length)))
    (string-append target-path path)))

(define (generate source) source)

(define (read-file file)
  (list->string
    (with-input-from-file file
      (lambda ()
        (let reading ((chars '()))
          (let ((char (read-char)))
            (if (eof-object? char)
                (reverse chars)
                (reading (cons char chars)))))))))

(define (display-list xs)
  (for-each
    (lambda (x)
      (display x)
      (newline))
    xs))

(define (main args)
  (let* ((source_dir (car args))
         (target_dir (car (cdr args))))
    (display (read-file "generate.sh"))
    (display-list (fs-find (dir-join (dirname (current-filename)) source_dir)))))
