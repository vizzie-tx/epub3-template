#!/bin/sh

# Programs
ZIP=/usr/bin/zip
XSLT=/usr/bin/saxonb-xslt
EPUBCHECK="/usr/bin/java -jar /usr/local/share/java/epubcheck-3.0.1/epubcheck-3.0.1.jar"
KINDLEGEN=/usr/local/bin/kindlegen

epub="Ebook.epub"
mobi=`basename .epub`.mobi
navdoc=OEBPS/navigation.xhtml
pkgdoc=OEBPS/content.opf
pkgdocb=`basename $pkgdoc`.bak
tocdoc=OEBPS/toc.ncx

# Preserve the original fonts before subsetting
mkdir -p fonts
for of in `find OEBPS/fonts -type f`; do
    sf=fonts/`basename $of`
    if [ ! -f "$sf" ]; then
	cp $of $sf
    fi
done

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
    ${KINDLEGEN} "$epub"
fi
