(define-module (dk climbing)
               #:use-module (haunt builder blog)
               #:use-module (haunt html)
               #:use-module (haunt page)
               #:use-module (srfi srfi-1)
               #:use-module (dk formats)
               #:use-module (dk svg)
               #:export (climbing-index-page))

(define star (embed-svg "feather/star.svg"))

(define (stars count)
  `(span ,(map (lambda (_) star) (iota count))))

(define* (route #:key name difficulty (safety "G") quality)
         (if (or (equal? safety "G") (equal? safety "PG"))
             `(li (h4 ,difficulty " " ,name))
             `(li (h4 ,difficulty "(" ,safety ") " ,name))))

(define* (boulder-problem #:key name difficulty (safety "G") quality)
         (if (or (equal? safety "G") (equal? safety "PG"))
             `(li (h4 ,difficulty " " ,name))
             `(li (h4 ,difficulty "(" ,safety ") " ,name))))

(define redpoints
  `(ul ,(route #:name "Psycho Crack Right"
               #:quality (stars 3)
               #:difficulty "5.8"
               #:safety "PG")
       ,(route #:name "Reach Around"
               #:quality (stars 2)
               #:difficulty "5.7")
       ,(route #:name "The Brat"
               #:quality (stars 2)
               #:difficulty "5.7"
               #:safety "5.5R")
       ,(route #:name "Laurel"
               #:quality (stars 2)
               #:difficulty "5.6"
               #:safety "PG")))

(define onsights
  `(ul ,(route #:name "Moonlight"
               #:quality (stars 4)
               #:difficulty "5.5"
               #:safety "PG13")
       ,(route #:name "High Exposure"
               #:quality (stars 4)
               #:difficulty "5.6")
       ,(route #:name "First Day"
               #:quality (stars 2)
               #:difficulty "5.7")
       ,(route #:name "Genuflect"
               #:quality (stars 2)
               #:difficulty "5.6"
               #:safety "PG")
       ,(route #:name "Eyesore"
               #:quality (stars 2)
               #:difficulty "5.7"
               #:safety "PG")
       ,(route #:name "Genuflect"
               #:quality (stars 2)
               #:difficulty "5.6"
               #:safety "PG")
       ,(route #:name "Cool Hand Luke"
               #:quality (stars 2)
               #:difficulty "5.6")))

(define other-leads
  `(ul ,(route #:name "Cat in the Hat"
               #:quality (stars 4)
               #:difficulty "5.6"
               #:safety "PG")
       ,(route #:name "Big Bad Wolf"
               #:quality (stars 3)
               #:difficulty "5.9")
       ,(route #:name "Madame Grunnebaum's Wulst"
               #:quality (stars 3)
               #:difficulty "5.6"
               #:safety "PG")
       ,(route #:name "Shockley's Ceiling"
               #:quality (stars 3)
               #:difficulty "5.6")
       ,(route #:name "Baby"
               #:quality (stars 3)
               #:difficulty "5.6"
               #:safety "PG")
       ,(route #:name "Bolt Line"
               #:quality (stars 2)
               #:difficulty "5.6"
               #:safety "PG")
       ,(route #:name "City Lights"
               #:quality (stars 2)
               #:difficulty "5.8"
               #:safety "5.6PG13")
       ,(route #:name "Beginner's Delight"
               #:quality (stars 1)
               #:difficulty "5.4"
               #:safety "R")))

(define boulders
  `(ul ,(boulder-problem #:name "M4"
                         #:quality (stars 4)
                         #:difficulty "V2")
       ,(boulder-problem #:name "Suzie A"
                         #:quality (stars 4)
                         #:difficulty "V1"
                         #:safety "PG13")))

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

