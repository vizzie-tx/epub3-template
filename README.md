epub3-template
==============

An epub3 boilerplate and build skeleton.

Software required:
zip - for building epub3 package
epubcheck - for validating epub3 file
kindlegen - for building .mobi package from epub3
saxonb-xslt - XSLT2 processor to update content.opf and toc.ncx

To use:
1. Create content in OEBPS directory. 
2. Update navigation.xhtml with links to content files
3. Update OEBPS/content.opf. Make sure all files in OEBPS directory
   are included.
4. Run ./build.sh - this will:
    a. Backup the OEBPS/fonts directory
    b. Regenerate the toc.ncx file from navigation.xhtml
    c. Update content.opf - add a GUID if the dc:identifer field is blank,
       and update the dcterms:modified meta with the current UTC date
    d. Build the epub file
    e. Validate the epub file using epubcheck
    f. If successful, builds a kindle .mobi file

Notes:
------

* The content.opf file will be backed up as content.opf.bak, in case
  anything goes wrong with the xslt update.

