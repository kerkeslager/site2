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
             (web uri)

             (dk climbing)
             (dk formats))

(define (index-page site posts)
	(make-page "index.html"
						 (with-layout haunt-theme site "Home"
                          "My name is David and this is my new website. Check it out.")
						 sxml->html))

(define %collections
  `(("Blog" "index.html" ,posts/reverse-chronological)))

(site #:title "David Kerkeslager's Website"
      #:domain "kerkeslager.com"
      #:default-metadata
      '((author . "David Kerkeslager"))
      #:readers (list sxml-reader html-reader)
      #:builders (list index-page
                       climbing-index-page
                       climbing-redpoints-index-page
                       climbing-onsights-index-page
                       climbing-other-leads-index-page
                       climbing-boulder-problems-index-page
                       (static-directory "img")
                       (static-directory "css")
                       (static-directory "misc" "")
                       (blog #:collections %collections #:prefix "blog/" #:theme haunt-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)))
