#/bin/sh

# update firefox-related repos weekly
cd $HOME/Documents/code/repos

# user.js - betterfox and narsil user.js
cd user.js
git pull
cd ..
cd Betterfox
git pull

# cascade
cd cascade
git pull
