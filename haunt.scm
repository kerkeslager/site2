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
             (srfi srfi-19)
             (ice-9 rdelim)
             (ice-9 match)
             (web uri))

(define (stylesheet name)
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/css/" name ".css")))))

(define (anchor content uri)
  `(a (@ (href ,uri)) ,content))

(define (haunt-layout site title body)
  `((doctype "html")
    (head
      (meta (@ (charset "utf-8")))
      (title ,(string-append title " — " (site-title site)))
      ,(stylesheet "reset")
      ,(stylesheet "style"))
    (body
      (header "Header")
      (nav
        (ul
          (li ,(anchor "home" "/"))
          (li ,(anchor "blog" "/blog/"))))
      (main ,body)
      (footer
        (a (@ (rel "license") (href "http://creativecommons.org/licenses/by-sa/4.0/"))
           (img (@ (alt "Creative Commons License") (style "border-width:0") (src "https://i.creativecommons.org/l/by-sa/4.0/88x31.png"))))
        (br)
        "This work is licensed under a"
        (a (@ (rel "license") (href "http://creativecommons.org/licenses/by-sa/4.0/")) "Creative Commons Attribution-ShareAlike 4.0 International License")
        "."))))

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
             (with-layout haunt-theme site "Downloads" "Homepage body content")
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
                       (static-directory "img")
                       (static-directory "css")
                       (blog #:collections %collections #:prefix "blog/" #:theme haunt-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)))
