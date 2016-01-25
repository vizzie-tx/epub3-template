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
