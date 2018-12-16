(define-module (dk formats)
  #:use-module (haunt builder blog)
  #:use-module (haunt post)
  #:use-module (haunt site)
  #:use-module (srfi srfi-19)
  #:use-module (dk svg)
  #:export (format-date
            haunt-theme))

(define (format-date date)
  (date->string date "~Y ~m ~d"))

(define (stylesheet name)
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/css/" name ".css")))))

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
          (p "© 2018 David Kerkeslager")
          (p "Site built with "
             (a (@ (href "https://dthompson.us/projects/haunt.html")) "Haunt") ".")
          (section (@ (class "licenses"))
                   "Licenses: "
                   (div
                     (span "Content: "
                           (a (@ (rel "license") (href "http://creativecommons.org/licenses/by-sa/4.0/"))
                              "CC BY-SA 4.0"))
                     (span "Code: "
                           (a (@ (rel "license") (href "https://www.gnu.org/licenses/gpl.html"))
                              "GPL 3.0")))))))))

(define (haunt-post-template post)
  `(article (h1 ,(post-ref post 'title))
						(div (@ (class "date")) ,(format-date (post-date post)))
						(div ,(post-sxml post))))

(define (haunt-collection-template site title posts prefix)
	(define (post-uri post)
		(string-append "/" (or prefix "")
									 (site-post-slug site post) ".html"))

	`((h1 "Blog")
    (a (@ (href "/feed.xml")
          (class "rss"))
       ,(embed-svg "feather/rss.svg"))
		(ul (@ (class "blog-index"))
        ,@(map (lambda (post)
								 `(li
										(a (@ (href ,(post-uri post)))
											 ,(format-date (post-date post))
											 " — "
											 ,(post-ref post 'title))))
							 (posts/reverse-chronological posts)))))

(define haunt-theme
	(theme #:name "Haunt"
				 #:layout haunt-layout
				 #:post-template haunt-post-template
				 #:collection-template haunt-collection-template))
