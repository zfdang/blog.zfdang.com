#!/bin/bash
echo "$ hexo generate"
hexo generate
echo "$ git status"
git status
echo "$ git add ."
git add .
echo """$ git commit -a -m "update""""
git commit -a -m "update"
echo "$ git push"
git push