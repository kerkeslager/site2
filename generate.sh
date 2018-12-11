#!/usr/bin/env bash

# rsync -rtuc --delete site_source/ site/

guile -e main -s generate.scm site_source
