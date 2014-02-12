epub3-template
==============

An epub3 boilerplate and build skeleton.

Software required:

* zip - for building epub3 package
* epubcheck - for validating epub3 file
* kindlegen - for building .mobi package from epub3
* saxonb-xslt - XSLT2 processor to update content.opf and toc.ncx

To use:
<ol>
 <li>Create content in OEBPS directory. 
 <li>Update navigation.xhtml with links to content files
 <li>Update OEBPS/content.opf. Make sure all files in OEBPS directory
   are included.
 <li>Run ./build.sh - this will:
    <ol>
     <li>Backup the OEBPS/fonts directory
     <li>Regenerate the toc.ncx file from navigation.xhtml
     <li>Update content.opf - add a GUID if the dc:identifer field is blank,
       and update the dcterms:modified meta with the current UTC date
     <li>Build the epub file
     <li>Validate the epub file using epubcheck
     <li>If successful, builds a kindle .mobi file
  </ol>
<ol>
Notes:
------

* The content.opf file will be backed up as content.opf.bak, in case
  anything goes wrong with the xslt update.

