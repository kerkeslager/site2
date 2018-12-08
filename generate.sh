#!/usr/bin/env bash

# rsync -rtuc --delete site_source/ site/

guile -s generate.scm
