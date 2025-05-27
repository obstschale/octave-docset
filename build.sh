#!/bin/sh
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

VERSION=10.1.0
PACKAGE="Octave-doc-$VERSION.tgz"
DOC_DIR=v$VERSION
DOC_HOST="docs.octave.org"
DOC_URL="https://$DOC_HOST/$DOC_DIR/"
LOC_DIR="/usr/share/doc/octave/octave.html"

if [ ! -f "$PACKAGE" ]; then
    printf "${GREEN}Starting to build octave.docset for version $VERSION${NC}\n"

    version=
    [ -f .version ] && version=$( cat .version )

    if [ ! .$VERSION = .$version ]; then
        # clean up previous remains, if any
        rm -rf Contents/Resources
        rm -rf Octave.docset

        # prepare to grab the files
        mkdir -p Contents/Resources
        cd Contents/Resources

        # try first installed local Octave documentation
        if [ -d "${LOC_DIR}" ]; then
            printf "${GREEN}Using local octave html doc.${NC}\n"
            cp -a "${LOC_DIR}" ./Documents

            if [ ! -f "Documents/Function-Index.html" -o ! -f "Documents/Concept-Index.html" -o \
                 ! -f "Documents/Operator-Index.html" -o ! -f "Documents/Graphics-Properties-Index.html" -o \
                 ! -f "Documents/index.html" ]; then
                printf "${RED}Local directory lack the needed files.${NC}\n"
                rm -rf ./Documents
            else
                VERSION=$( cat ./Documents/index.html | sed -En "s,.*GNU\s+Octave[ \t({]*(version|)\s*([0-9][0-9.]+\b).*,\2,; T; p; q" )
                PACKAGE="Octave-doc-$VERSION.tgz"
                echo "$VERSION" > ../../.version
            fi
        fi

        if [ ! -d ./Documents ]; then
            # fetch the whole doc site
            printf "${GREEN}Starting to download Octave $VERSION documentation from $DOC_URL${NC}\n"
            wget --mirror --page-requisites --adjust-extension --convert-links --no-parent -e robots=off --show-progress --quiet "$DOC_URL"

            # change folder name to just Documents
            mv $DOC_HOST/$DOC_DIR ./Documents
            rm -rf $DOC_HOST

            if [ ! -f "Documents/Function-Index.html" -o ! -f "Documents/Concept-Index.html" -o \
                 ! -f "Documents/Operator-Index.html" -o ! -f "Documents/Graphics-Properties-Index.html" -o \
                 ! -f "Documents/index.html" ]; then
                printf "${RED}WARNING - wget failed at mirroring properly the site.${NC}\n"
                exit 1
            else
                echo "$VERSION" > ../../.version
            fi
        fi
        cd ../../

    fi

    # bundle up!
    printf "${GREEN}Building the Octave.docset folder...${NC}\n"

    if [ ! -d Octave.docset ]; then
        mkdir Octave.docset
        cp -r Contents Octave.docset/
        cp assets/icon* Octave.docset/

        cat << __EOF_ >> Octave.docset/meta.json
{
    "name": "Octave",
    "title": "Octave",
    "urls": [
        "http://london.kapeli.com/feeds/zzz/user_contributed/build/Octave/Octave.tgz"
    ],
    "version": "$VERSION"
}
__EOF_

        cat << __EOF_ >> Octave.docset/Contents/Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleIdentifier</key>
  <string>octave</string>
  <key>CFBundleName</key>
  <string>Octave</string>
  <key>DocSetPlatformFamily</key>
  <string>octave</string>
  <key>isDashDocset</key>
  <true/>
  <key>dashIndexFilePath</key>
  <string>index.html</string>
</dict>
</plist>
__EOF_

    fi

    # create data file from base index page
    python3 octdoc2set.py

    if [ $? -eq 1 ]; then
        printf "${RED}Error: Could not build Docset${NC}\n"
        exit 1;
    fi

    # Create gzip bundle for Dash Contribution
    printf "${GREEN}Archiving to $PACKAGE ...${NC}\n"
    tar --remove-files --exclude='.DS_Store' -czf $PACKAGE Octave.docset
    printf "${GREEN}Finished!${NC}\n"
else
    printf "${GREEN}Archive: $PACKAGE alread exist.${NC}\n"
fi
