<?xml version="1.0" ?>
<xsl:stylesheet version="2.0"
		xmlns:uuid="java:java.util.UUID"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:d="http://www.idpf.org/2007/opf"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:dcterms="http://purl.org/dc/terms/">

  
  <xsl:variable name="GMT" select="xs:dayTimeDuration('PT0H')"/>
  <xsl:variable name="format" select="'[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]Z'" />
  <xsl:variable name="datetime" select="current-dateTime()"/>
  <xsl:variable name="utc-datetime"
		select="adjust-dateTime-to-timezone($datetime, $GMT)" />
  <xsl:variable name="utc-datestamp"
	        select="format-dateTime($utc-datetime, $format)" />
  <xsl:variable name="guid" select="uuid:randomUUID()"/>

  <xsl:template match="d:meta[@property='dcterms:modified']/text()">
    <xsl:value-of select="$utc-datestamp"/> 
  </xsl:template>

  <xsl:template match="dc:identifier[@id='pub-id']">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
      <xsl:if test="not(string(text()))">
	<xsl:value-of select="$guid" />
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <!-- IdentityTransform -->
  <xsl:template match="/ | @* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
