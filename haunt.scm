(use-modules (haunt site)
             (haunt reader)
             (haunt asset)
             (haunt page)
             (haunt post)
             (haunt html)
             (haunt utils)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
             (ice-9 rdelim)
             (ice-9 match)
             (srfi srfi-19)
             (sxml simple)
             (web uri))

(define (stylesheet name)
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/css/" name ".css")))))

(define (anchor content uri)
  `(a (@ (href ,uri)) ,content))

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

(define (haunt-layout site title body)
  `((doctype "html")
    (html
      (@ (lang "en"))
      (head
        (meta (@ (charset "utf-8")))
        (title ,(string-append title " — " (site-title site)))
        ,(stylesheet "reset")
        ,(stylesheet "style"))
      (body
        (nav (a (@ (href "/")) ,(embed-svg "feather/home.svg"))
             (a (@ (href "/blog/")) ,(embed-svg "feather/book.svg"))
             (a (@ (href "/climbing/")) ,(embed-svg "mountain.svg"))
             (a (@ (href "https://github.com/kerkeslager/")) ,(embed-svg "feather/code.svg")))
        (main ,body)
        (footer
          (p "This site was built with "
             (a (@ (href "https://dthompson.us/projects/haunt.html")) "Haunt") ".")
          (p
            (a (@ (rel "license") (href "http://creativecommons.org/licenses/by-sa/4.0/"))
               ,(embed-svg "by-sa.svg"))
            "All content is © 2018 by David Kerkeslager and released under the "
            (a (@ (rel "license") (href "http://creativecommons.org/licenses/by-sa/4.0/")) "Creative Commons Attribution-ShareAlike 4.0 International License")
            " unless otherwise specified."))))))

(define (haunt-post-template post)
  `((h2 ,(post-ref post 'title))
    (h3 "by " ,(post-ref post 'author)
        " — " ,(date->string* (post-date post)))
    (div ,(post-sxml post))))

(define (haunt-collection-template site title posts prefix)
  (define (post-uri post)
    (string-append "/" (or prefix "")
                   (site-post-slug site post) ".html"))

  `((h2 "Blog")
    (ul ,@(map (lambda (post)
                 `(li
                    (a (@ (href ,(post-uri post)))
                       ,(post-ref post 'title)
                       " — "
                       ,(date->string* (post-date post)))))
               (posts/reverse-chronological posts)))))

(define haunt-theme
  (theme #:name "Haunt"
         #:layout haunt-layout
         #:post-template haunt-post-template
         #:collection-template haunt-collection-template
         ))

(define (index-page site posts)
  (make-page "index.html"
             (with-layout haunt-theme site "Home" "Homepage body content")
             sxml->html))

(define (climbing-index-page site posts)
  (make-page "climbing/index.html"
             (with-layout haunt-theme site "Climbing" "Climbing body content")
             sxml->html))

(define %collections
  `(("Home" "index.html" ,posts/reverse-chronological)))

(site #:title "David Kerkeslager's Website"
      #:domain "kerkeslager.com"
      #:default-metadata
      '((author . "David Kerkeslager")
        (email  . "kerkeslager@riseup.net"))
      #:readers (list sxml-reader html-reader)
      #:builders (list index-page
                       climbing-index-page
                       (static-directory "img")
                       (static-directory "css")
                       (blog #:collections %collections #:prefix "blog/" #:theme haunt-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)))
