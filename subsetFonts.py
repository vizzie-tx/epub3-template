n#!/usr/bin/env python
# Copyright (c) 2014-2016 Larry Daffner

# Permission is hereby granted, free of charge, to any person
# obtaining a COPY of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
