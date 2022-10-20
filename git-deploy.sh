#!/bin/sh 

echo "Adding files to the local commit"
git add -A 

git commit -am "Pushing latest changes"

echo "Pushing to GitHub repository"
git push
