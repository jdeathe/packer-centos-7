#!/bin/bash -e

/bin/echo '--> Purging temporary directories.'
/bin/rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*
