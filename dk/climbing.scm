(define-module (dk climbing)
               #:use-module (haunt builder blog)
               #:use-module (haunt html)
               #:use-module (haunt page)
               #:use-module (srfi srfi-1)
               #:use-module (srfi srfi-19)
               #:use-module (dk formats)
               #:use-module (dk svg)
               #:export (climbing-index-page))

(define (make-date-easy year month day)
  (make-date 0 0 0 0 day month year 0))

(define star (embed-svg "feather/star.svg"))

(define (stars count)
  `(span (@ (class "stars")) ,(map (lambda (_) star) (iota count))))

(define (display-risky safety)
  (if (or (equal? safety "G") (equal? safety "PG"))
      " "
      (string-append "(" safety ") ")))

(define external-link-svg (embed-svg "feather/external-link.svg"))

(define (display-link-if-exists link)
  (if (eq? '() link)
      " "
      `(a (@ (href ,link)) ,external-link-svg)))

(define* (route #:key name date difficulty (safety "G") quality (link '()) description)
         `(section (@ (class "route"))
                   (h4 ,(stars quality)
                       ,difficulty
                       ,(display-risky safety)
                       ,name
                       " " ,(display-link-if-exists link))
                   (time ,(format-date date))
                   ,description))

(define* (boulder-problem #:key name date difficulty (safety "G") quality (link '()) description)
         `(section (@ (class "route"))
                   (h4 ,(stars quality)
                       ,difficulty
                       ,(display-risky safety)
                       ,name
                       " " ,(display-link-if-exists link))
                   (time ,(format-date date))
                   ,description))

(define redpoints
  `(div (@ (class "route-list"))
     ,(route #:name "Psycho Crack Right"
               #:date (make-date-easy 2018 10 22)
               #:quality 4
               #:difficulty "5.8"
               #:safety "PG"
               #:description '(div (p "One of the finest routes in Peterskill. In one pitch you get
                                      a variety of climbing. The crux of the route is a short
                                      section of offwith.")
                                   (p "I toproped this climb a few times to get it clean, but
                                      didn't plan out the gear completely before I led it, so on
                                      lead I placed both my big pieces, a #4 and a #5, around the
                                      crux, which was already adequately protected with a green
                                      Totem. Above the crux, I found myself with more holds, but
                                      surprisingly few placements. It wasn't until the meat of the
                                      route was over a few body-lengths later that I got another
                                      piece.")))
       ,(route #:name "The Brat"
               #:date (make-date-easy 2018 7 7)
               #:quality 2
               #:difficulty "5.7"
               #:safety "5.5R"
               #:description '(div (p "This route was part of a lot of work on my lead head that I
                                      did this summer. The 5.7 crux is fairly straightforward, but
                                      it's followed by a long section of unprotected 5.5.")
                                   (p "I managed to place a black Totem cam in a pocket in the
                                      runout section, but when my follower arrived at it they
                                      laughed and removed it without even depressing the trigger.")))
       ,(route #:name "Reach Around"
               #:date (make-date-easy 2018 6 26)
               #:quality 2
               #:difficulty "5.7"
               #:description '(div (p "This route is fairly easy until its short, well-protected
                                      crux. This was my first 5.7 lead in the Gunks, so I was
                                      surprised to see that it was rated 5.8 on Mountain Project!
                                      I don't feel like it was that hard, but I've heard the crux
                                      was height-dependent, and I'm on the taller side of
                                      average.")))
       ,(route #:name "Laurel"
               #:date (make-date-easy 2018 5 24)
               #:quality 2
               #:difficulty "5.6"
               #:safety "PG"
               #:description '(div (p "The crux is the first few moves off the ground, so unlike
                                      most of my redpoints where I rehearsed the routes on top rope,
                                      I practiced just the crux of this with a boulder pad until
                                      I was confident.")
                                   (p "I intended for this to be my first 5.7, which is what
                                      guidebooks grade it, but when I did it, it felt easier than
                                      5.7, probably because the crux is height-dependent.")))))

(define onsights
  `(div (@ (class "route-list"))
        ,(route #:name "First Day"
                #:date (make-date-easy 2018 10 10)
                #:quality 2
                #:difficulty "5.7"
                #:description '(div (p "This was my first 5.7 onsight! However, like many Peterskill
                                       routes, this route is frequently top roped, and for rope
                                       management reasons the top rope route goes the straightest
                                       way, which leads up the right dihedral of a section that looks
                                       like a letter W. Leading, it felt more natural to go up the
                                       left dihedral. It felt a bit soft for 5.7 this way.")))
        ,(route #:name "High Exposure"
                #:date (make-date-easy 2018 8 20)
                #:quality 4
                #:difficulty "5.6"
                #:description '(div (p "Ever since I heard of this ultra-classic route, I wanted to
                                       onsight it. However, as soon as I felt strong enough to do
                                       so, that section of cliff was closed for peregrine falcon
                                       nesting. So I wasn't able to lead it for most of 2018.")
                                    (p "Finally, the peregrine falcon nesting closure was lifted,
                                       and I was able to lead this route, but I had already
                                       onsighted many climbs at the grade by this time, and even led
                                       a few harder climbs. It wasn't the challenge I had originally
                                       hoped it would be, but it was still an incredibly amazing
                                       climb, which absolutely deserves its reputation as a
                                       classic.")
                                    (p "It was also rewarding to see how much I had grown as a
                                       climber this summer. When I first dreamed of onsighting High
                                       E, it was a challenging goal, but when I finally got to climb
                                       it, it felt easy.")))
        ,(route #:name "Moonlight"
                #:date (make-date-easy 2018 8 10)
                #:quality 4
                #:difficulty "5.6"
                #:safety "PG13"
                #:description '(div (p "At the time of this writing, (December 2018) this is my
                                       favorite lead to date in the Gunks. Not only was this an
                                       extraordinary climb, but it represented the culmination of
                                       my work on my lead head this summer. The crux, frankly, is
                                       terrifying, and while the physical difficulty of the route
                                       was well within my capability when I led it, keeping calm
                                       while executing the crux moves is probably my proudest
                                       climbing achievement to date.")
                                    (p "The crux of this route is a delicate blind step left around
                                       an arete, after a significant traverse from your last piece
                                       of gear. There are no good holds to save you; you have to
                                       balance and trust your feet, while facing a large pendulum,
                                       all while in a wildly exposed position that you have to look
                                       down from in order to find your feet.")
                                    (p "In addition to the objective and perceived hazards of the
                                       crux to the leader, I also had to protect the follower from
                                       a pendulum. To complicate matters, I encountered a nest of
                                       yellow jackets between the crux and the last piece before
                                       the crux. I carefully avoided disturbing the nest, and after
                                       pulling the crux, I climbed up, placing gear and
                                       back-cleaning it until I was high enough above the crux
                                       traverse to reach out right and place a piece directly above
                                       the crux. This meant that instead of a violent pendulum, my
                                       follower would take a gentle swing on a top rope if they fell
                                       at the crux. I'm glad I did this, because my follower was
                                       stung by a yellow jacket and fell" (em "before") "the
                                       crux! Due to my careful planning he was unhurt except for
                                       the sting.")))
        ,(route #:name "Cool Hand Luke"
                #:date (make-date-easy 2018 7 9)
                #:quality 2
                #:difficulty "5.6"
                #:description '(div (p "This was my first onsight at the grade. I've since found
                                       that it's a bit difficult for 5.6, which I'm glad I didn't
                                       know at the time.")))))

(define other-leads
  `(div (@ (class "route-list"))
        ,(route #:name "Cat in the Hat"
                #:date (make-date-easy 2018 4 8)
                #:quality 4
                #:difficulty "5.6"
                #:safety "PG"
                #:description '(div (p "Swapped leads.")))
        ,(route #:name "Big Bad Wolf"
                #:date (make-date-easy 2018 4 7)
                #:quality 3
                #:difficulty "5.9"
                #:description '(div (p "Led the middle (5.8) pitch.")))
        ,(route #:name "Madame Grunnebaum's Wulst"
                #:date (make-date-easy 2018 9 30)
                #:quality 3
                #:difficulty "5.6"
                #:safety "PG"
                #:description '(div (p "Description")))
        ,(route #:name "Shockley's Ceiling"
                #:date (make-date-easy 2018 8 9)
                #:quality 3
                #:difficulty "5.6"
                #:description '(div (p "Description")))
        ,(route #:name "Baby"
                #:date (make-date-easy 2018 10 10)
                #:quality 3
                #:difficulty "5.6"
                #:safety "PG"
                #:description '(div (p "Description")))
        ,(route #:name "Bolt Line"
                #:date (make-date-easy 2018 7 29)
                #:quality 2
                #:difficulty "5.8"
                #:safety "PG"
                #:description '(div (p "First attempt to onsight 5.8. I hung on the early crux, then re-attempted from the ground and got it.")))
        ,(route #:name "City Lights"
                #:date (make-date-easy 2018 6 19)
                #:quality 2
                #:difficulty "5.8"
                #:safety "5.6PG13"
                #:description '(div (p "First lead at the grade.")))
        ,(route #:name "Beginner's Delight"
                #:date (make-date-easy 2017 10 15)
                #:quality 1
                #:difficulty "5.4"
                #:safety "R"
                #:description '(div (p "First serious trad lead fall, a 30 footer onto a #3. Thanks LB for the catch!")))))

(define boulders
  `(div (@ (class "route-list"))
        ,(boulder-problem #:name "M4"
                          #:date (make-date-easy 2018 12 11)
                          #:quality 4
                          #:difficulty "V2"
                          #:description '(div (p "Description")))
        ,(boulder-problem #:name "Suzie A"
                          #:date (make-date-easy 2018 9 8)
                          #:quality 4
                          #:difficulty "V1"
                          #:safety "PG13"
                          #:description '(div (p "Description")))))

(define redpoints-section
  `(section (h2 "Redpoints")
            (p "These are climbs that I spent a significant amount of time working on before I was able to lead climb them without falling.")
            ,redpoints))

(define onsights-section
  `(section (h2 "Onsights")
            (p "These are climbs that I climbed on the first try without beta and without weighting the rope.")
            ,onsights))

(define other-leads-section
  `(section (h2 "Other leads")
            (p "These are leads that I didn't redpoint or onsight, but are worth mentioning.")
            ,other-leads))

(define boulder-problems-section
  `(section (h2 "Boulder problems")
            (p "I'm not much of a boulderer, but here are a few boulder problems I've done.")
            ,boulders))

(define selected-leads
  `(section (h1 "Selected Leads")
            (p "This is an abridged list of the things I've climbed. I included climbs either because I'm proud of having lead them, or because they were memorable or enjoyable.")
            ,redpoints-section
            ,onsights-section
            ,other-leads-section
            ,boulder-problems-section))


(define (climbing-index-page site posts)
  (make-page "climbing/index.html"
             (with-layout haunt-theme site "Climbing" selected-leads)
             sxml->html))

