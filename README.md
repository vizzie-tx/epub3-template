epub3-template
==============

An epub3 boilerplate and build skeleton.

Software required:
zip - for building epub3 package
epubcheck - for validating epub3 file
kindlegen - for building .mobi package from epub3
saxonb-xslt - XSLT2 processor to update content.opf and toc.ncx

To use:
  1) Create content in OEBPS directory. 
  2) Update navigation.xhtml with links to content files
  3) Update OEBPS/content.opf. Make sure all files in OEBPS directory
     are included.
  4) Run ./build.sh - this will:
      1) Backup the OEBPS/fonts directory
      2) Regenerate the toc.ncx file from navigation.xhtml
      3) Update content.opf - add a GUID if the dc:identifer field is blank,
         and update the dcterms:modified meta with the current UTC date
      4) Build the epub file
      5) Validate the epub file using epubcheck
      6) If successful, builds a kindle .mobi file

Notes:
------

* The content.opf file will be backed up as content.opf.bak, in case
  anything goes wrong with the xslt update.

