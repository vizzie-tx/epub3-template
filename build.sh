#!/bin/sh

# Options
epub="Ebook.epub"
GEN_KINDLE=true
SUBSET_FONTS=true

# Programs
ZIP=/usr/bin/zip
XSLT=/usr/bin/saxonb-xslt
EPUBCHECK="/usr/bin/java -jar /usr/local/share/java/epubcheck-3.0.1/epubcheck-3.0.1.jar"
KINDLEGEN=/usr/local/bin/kindlegen
BASEDIR=`pwd`

mobi=`basename .epub`.mobi
navdoc=OEBPS/navigation.xhtml
pkgdoc=OEBPS/content.opf
pkgdocb=`basename $pkgdoc`.bak
tocdoc=OEBPS/toc.ncx

if $SUBSET_FONTS; then
    # Preserve the original fonts before subsetting
    mkdir -p fonts
    for of in `find OEBPS/fonts -type f`; do
        sf=fonts/`basename $of`
        if [ ! -f "$sf" ]; then
	    cp $of $sf
	else
	    cp $sf $of
        fi
    done
    pwd
    $BASEDIR/subsetFonts.py OEBPS OEBPS/fonts/*
    rm OEBPS/fonts/*.bak
fi

# update the date in the package doc
cp $pkgdoc $pkgdocb
${XSLT} -ext:on $pkgdocb xslt/update-opf.xsl > ${pkgdoc}

# Regenerate the TOC file
${XSLT} $navdoc xslt/navdoc2ncx.xsl > $tocdoc

rm "$epub"
${ZIP} "$epub" -DX0 mimetype
${ZIP} "$epub" -rDX9 META-INF OEBPS --exclude OEBPS/\*template.xhtml \*/.gitignore
${EPUBCHECK} "$epub"

if [ $? = 0 ]; then
    if $GEN_KINDLE; then
        ${KINDLEGEN} "$epub"
    fi
fi


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
