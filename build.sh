VERSION=v4.2.1
DOCS_URL=https://www.gnu.org/software/octave/doc/$VERSION/

# clean up previous remains, if any
rm -rf Contents/Resources
rm -rf Octave.docset
mkdir -p Contents/Resources

# fetch the whole doc site
cd Contents/Resources
wget -m -p -E -k -np $DOCS_URL

# change folder name to just Documents
mv www.gnu.org/software/octave/doc/$VERSION ./Documents
rm -rf www.gnu.org
cd ../../

# bundle up!
mkdir Octave.docset
cp -r Contents Octave.docset
cp assets/icon* Octave.docset

# create data file from base index page
python octdoc2set.py

# Create gzip bundle for Dash Contribution
tar --exclude='.DS_Store' -cvzf Octave.tgz Octave.docset
