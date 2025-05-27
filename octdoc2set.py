#!/usr/bin/env python

import os, re, sqlite3
from bs4 import BeautifulSoup, NavigableString, Tag

db = sqlite3.connect('Octave.docset/Contents/Resources/docSet.dsidx')
cur = db.cursor()

try: cur.execute('DROP TABLE searchIndex;')
except: pass
cur.execute('CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);')
cur.execute('CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);')

docpath = 'Octave.docset/Contents/Resources/Documents'

pages = {
    "Function": "Function-Index.html",
    "Guide": "Concept-Index.html",
    "Operator": "Operator-Index.html"
    }

# loop through each index page
for p in pages:
    type = p
    page = open(os.path.join(docpath, pages[p])).read()
    soup = BeautifulSoup(page, 'html.parser')
    any = re.compile('.*')

    for td in soup.find_all('td', attrs={"valign": "top"}):
        for a in td.find_all('a'):
            name = a.text.strip()
            if len(name) > 0:
                path = a.attrs['href'].strip()
                if path.split('#')[0] not in ('index.html', 'biblio.html', 'bookindex.html'):
                    # check if fct name is already in DB
                    cur.execute('SELECT * FROM searchIndex WHERE name = ?', (name,) )
                    if cur.fetchone() is None:
                        # if name starts with - it is a command
                        if name[0] == "-" and len(name) > 3:
                            temp = type
                            type = "Command"

                        # save fct to DB
                        cur.execute('INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?,?,?)', (name, type, path))
                        print('name: %s' % (name))
                        print('\ttype: %s' % (type))
                        print('\tpath: %s' % (path))

                        # reste type
                        if name[0] == "-" and len(name) > 3:
                            type = temp


db.commit()
db.close()
