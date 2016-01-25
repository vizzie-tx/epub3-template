epub3-template
==============

An epub3 boilerplate and build skeleton.

Software required:

* zip - for building epub3 package
* epubcheck - for validating epub3 file
* kindlegen - for building .mobi package from epub3
* saxonb-xslt - XSLT2 processor to update content.opf and toc.ncx

To use:
 1. Create content in OEBPS directory. 
 2. Update navigation.xhtml with links to content files
 3. Update OEBPS/content.opf. Make sure all files in OEBPS directory are included.
 4. Set the name of the epub in build.sh
 4. Run ./build.sh - this will:
    1. Backup each font in ./fonts if a backup doesn't exist
    2. Restore each font from backup if a backup does exist
    3. Subset all fonts
    4. Update content.opf - add a GUID if the dc:identifer field is blank,
   and update the dcterms:modified meta with the current UTC date
    5. Regenerate the toc.ncx file from navigation.xhtml
    6. Build the epub file
    7. Validate the epub file using epubcheck
    8. If successful, builds a kindle .mobi file



Notes:
------

* The content.opf file will be backed up as content.opf.bak, in case
  anything goes wrong with the xslt update.
* Font manipulation can be disabled by setting SUBSET_FONTS to false in build.sh
* .mobi generation can be disabled by setting GEN_KINDLE to false in build.sh

