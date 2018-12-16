(define-module (dk climbing)
               #:use-module (haunt builder blog)
               #:use-module (haunt html)
               #:use-module (haunt page)
               #:use-module (dk formats)
               #:export (climbing-index-page))

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

