#!/bin/bash
git status
hexo generate
git add .
git commit -a -m "update"
git push