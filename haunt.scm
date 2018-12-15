;;; Haunt --- Static site generator for GNU Guile
;;; Copyright © 2015 David Thompson <davet@gnu.org>
;;;
;;; This file is part of Haunt.
;;;
;;; Haunt is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; Haunt is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with Haunt.  If not, see <http://www.gnu.org/licenses/>.

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

(define %releases
  '(("0.1" "c81dbcdf33f9b0a19442d3701cffa3b60c8891ce")))

(define (tarball-url version)
  (string-append "http://files.dthompson.us/haunt/haunt-"
                 version ".tar.gz"))

(define %download-button
  (match %releases
    (((version sha1) . _)
     `(a (@ (class "btn btn-primary btn-lg")
            (role "button")
            (href ,(tarball-url version)))
         "Download Haunt " ,version))))

(define (stylesheet name)
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/css/" name ".css")))))

(define (anchor content uri)
  `(a (@ (href ,uri)) ,content))

(define (logo src)
  `(img (@ (class "logo") (src ,(string-append "/images/" src)))))

(define (jumbotron content)
  `(div (@ (class "jumbotron"))
        (div (@ (class "row"))
             (div (@ (class "column-logo"))
                  (img (@ (class "big-logo")
                          (src "/images/haunt.png"))))
             (div (@ (class "column-info")) ,content))))

(define %cc-by-sa-link
  '(a (@ (href "https://creativecommons.org/licenses/by-sa/4.0/"))
      "Creative Commons Attribution Share-Alike 4.0 International"))

(define haunt-theme
  (theme #:name "Haunt"
         #:layout
         (lambda (site title body)
           `((doctype "html")
             (head
              (meta (@ (charset "utf-8")))
              (title ,(string-append title " — " (site-title site)))
              ,(stylesheet "reset")
              ,(stylesheet "main"))
             (body
               (header "Header")
              (nav
                           (ul
                            (li ,(anchor "home" "/"))
                            (li ,(anchor "blog" "/blog/"))))
              (main ,body)
              (footer))))
         #:post-template
         (lambda (post)
           `((h2 ,(post-ref post 'title))
             (h3 "by " ,(post-ref post 'author)
                 " — " ,(date->string* (post-date post)))
             (div ,(post-sxml post))))
         #:collection-template
         (lambda (site title posts prefix)
           (define (post-uri post)
             (string-append "/" (or prefix "")
                            (site-post-slug site post) ".html"))

           `(

             (h2 "News")
             (ul ,@(map (lambda (post)
                       `(li
                         (a (@ (href ,(post-uri post)))
                            ,(post-ref post 'title)
                            " — "
                            ,(date->string* (post-date post)))))
                     (posts/reverse-chronological posts)))


              ))))

(define (index-page site posts)

  (make-page "index.html"
             (with-layout haunt-theme site "Downloads" "Homepage body content")
             sxml->html))

(define %collections
  `(("Home" "index.html" ,posts/reverse-chronological)))

(site #:title "Haunt"
      #:domain "dthompson.us"
      #:default-metadata
      '((author . "David Thompson")
        (email  . "davet@gnu.org"))
      #:readers (list sxml-reader html-reader)
      #:builders (list (blog #:collections %collections #:prefix "blog/" #:theme haunt-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       index-page
                       (static-directory "img")
                       (static-directory "css")))
