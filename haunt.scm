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

             (dk formats)
             (dk svg))

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

(define (index-page site posts)
	(make-page "index.html"
						 (with-layout haunt-theme site "Home"
                          "My name is David and this is my new website. Check it out.")
						 sxml->html))

(define redpoints
  '(ul (li "5.8 Psycho Crack Right")
       (li "5.7 Reach Around")
       (li "5.7 Kling-on")
       (li "5.7(5.5R) The Brat")
       (li "5.6 Laurel")))

(define onsights
  '(ul (li "5.6(PG13) Moonlight")
       (li "5.6 High Exposure")
       (li "5.6 Baby")
       (li "5.7 First Day")
       (li "5.6 Sundance")
       (li "5.6 Genuflect")
       (li "5.6(PG13) Eyesore")
       (li "5.5 Ursula")))

(define other-leads
  '(ul (li "5.6 Cat in the Hat")
       (li "5.9 Big Bad Wolf")
       (li "5.6 Madame Grunnebaum's Wulst")
       (li "5.6 Shockley's Ceiling")
       (li "5.8 Bolt Line")
       (li "5.8(5.6PG13) City Lights")
       (li "5.4(R) Beginner's Delight")))

(define boulders
  '(ul (li "V2 M4")
       (li "V1(PG13) Suzie A")))

(define selected-leads
  `(section (h2 "Selected Leads")
            (p "This is an abridged list of the things I've climbed. I included climbs either because I'm proud of having lead them, or because they were memorable or enjoyable.")
            (section (h3 "Redpoints")
                     (p "These are climbs that I spent a significant amount of time working on before I was able to lead climb them without falling.")
                     ,redpoints)
            (section (h3 "Onsights")
                     (p "These are climbs that I climbed on the first try without beta and without weighting the rope.")
                     ,onsights)
            (section (h3 "Other leads")
                     (p "These are leads that I didn't redpoint or onsight, but are worth mentioning.")
                     ,other-leads)
            (section (h3 "Boulder problems")
                     (p "I'm not much of a boulderer, but here are a few boulder problems I've done.")
                     ,boulders)))


(define (climbing-index-page site posts)
  (make-page "climbing/index.html"
             (with-layout haunt-theme site "Climbing" selected-leads)
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
                       (static-directory "img")
                       (static-directory "css")
                       (blog #:collections %collections #:prefix "blog/" #:theme haunt-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)))
