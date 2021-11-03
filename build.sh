#!/bin/sh
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

VERSION=v6.4.0
DOCS_URL=https://octave.org/doc/$VERSION/
printf "${GREEN}Starting to build octave.docset for version $VERSION${NC}\n"

# clean up previous remains, if any
rm -rf Contents/Resources
rm -rf Octave.docset
mkdir -p Contents/Resources

# fetch the whole doc site
cd Contents/Resources
printf "${GREEN}Starting to download Octave $VERSION documentation from $DOCS_URL${NC}\n"
wget --mirror --page-requisites --adjust-extension --convert-links --no-parent --quiet --show-progress $DOCS_URL

# change folder name to just Documents
mv octave.org/doc/$VERSION ./Documents
rm -rf octave.org
cd ../../

# bundle up!
printf "${GREEN}Building the Octave.docset folder...${NC}\n"
mkdir Octave.docset
cp -r Contents Octave.docset
cp assets/icon* Octave.docset

# create data file from base index page
python3 octdoc2set.py

if [ $? -eq 1 ]
then
   printf "${RED}Error: Could not build Docset${NC}\n"
   exit 1;
fi

# Create gzip bundle for Dash Contribution
printf "${GREEN}Archiving to Octave.tgz ...${NC}\n"
tar --exclude='.DS_Store' -cvzf Octave.tgz Octave.docset

printf "${GREEN}Finished!${NC}\n"
