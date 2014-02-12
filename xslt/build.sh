#!/bin/sh

epub="Name.epub"
mobi=`basename  .epub`.mobi
navdoc=OEBPS/navigation.xhtml
pkgdoc=OEBPS/content.opf
tocdoc=OEBPS/toc.ncx

# Preserve the original fonts before subsetting
mkdir -p fonts
for of in OEBPS/fonts/*; do
    sf=`basename $of`
    if [ ! -f "$sf" ]; then
	cp $of $sf
    fi
done

# Regenerate the TOC file
saxonb-xslt $navdoc xslt/navdoc2ncx.xsl > $tocdoc

# update the date in the package doc
saxonb-xslt $pkgdoc xslt/update-opf.xsl > ${pkgdoc}.new
mv $pkgdoc.new $pkgdoc

rm "$epub"
zip "$epub" -DX0 mimetype
zip "$epub" -rDX9 META-INF OEBPS
epubcheck "$epub"

if [ $\? = 0 ]; then
    kindlegen "$epub"
fi
