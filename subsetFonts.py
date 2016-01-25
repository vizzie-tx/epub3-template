#!/usr/bin/env python

import os, sys, codecs, re
from HTMLParser import HTMLParser
from htmlentitydefs import name2codepoint
import fontforge

cps = set();
# create a subclass and override the handler methods
class MyHTMLParser(HTMLParser):
    def __init__(self):
	HTMLParser.__init__(self)
        self.outdata = u""
    def handle_data(self, data):
 	data = re.sub(r"[\t\r\n ]+", " ", data);
        self.outdata += data
    def handle_entityref(self, name):
        try:
            c = unichr(name2codepoint[name])
        except KeyError:
	    if (name == 'apos'):
                c = unichr(8217)
		#c = unichr(39)
            else:
                c = ""
        self.outdata += c
    def get_results(self):
	return self.outdata

for dtuple in os.walk(sys.argv[1]):
    d, ds, fs = dtuple
    for f in fs:
        if (f.lower().endswith('.xhtml') or
            f.lower().endswith('.html') or
            f.lower().endswith('.xml')):
            path =  os.path.join(d, f)
            parser = MyHTMLParser()
            inp = codecs.open(path, encoding='utf-8')
            for line in inp:
                parser.feed(line)
            parser.close()
            print parser.get_results();
            for c in parser.get_results():
                cps.add(c)

for fontfile in sys.argv[2:]:
    font = fontforge.open(fontfile)
    font.selection.none()
    for c in list(cps):
        font.selection.select(("unicode", "more"), ord(c))
    font.selection.invert()
    font.clear()
    os.rename(fontfile,  fontfile + ".bak")
    font.generate(fontfile)
