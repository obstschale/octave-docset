#!/bin/sh
VERSION=v4.2.1
DOCS_URL=https://www.gnu.org/software/octave/doc/$VERSION/
echo -e "Starting to build octave.docset for version $VERSION"

# clean up previous remains, if any
rm -rf Contents/Resources
rm -rf Octave.docset
mkdir -p Contents/Resources

# fetch the whole doc site
cd Contents/Resources
echo -e "Starting to download Octave $VERSION documentation from $DOCS_URL"
wget -m -p -E -k -np $DOCS_URL

# change folder name to just Documents
mv www.gnu.org/software/octave/doc/$VERSION ./Documents
rm -rf www.gnu.org
cd ../../

# bundle up!
echo -e "Building the Octave.docset folder..."
mkdir Octave.docset
cp -r Contents Octave.docset
cp assets/icon* Octave.docset

# create data file from base index page
python octdoc2set.py

# Create gzip bundle for Dash Contribution
echo -e "Archiving to Octave.tgz ..."
tar --exclude='.DS_Store' -cvzf Octave.tgz Octave.docset
