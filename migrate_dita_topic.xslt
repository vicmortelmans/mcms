<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <!-- This transformation is run from migrate.py.
        - add DOCTYPE
        - remove @ixia_locid attributes
        - rename references to resources from .res to .zip
        - rename references to images from .image to .svg
          (the files themselves are renamed by migrate.py)
    -->
  <xsl:template match="/">
    <!-- set doctype, can't use attributes in xsl:output, because it's dynamic -->
    <xsl:variable name="doctype.public">
      <xsl:choose>
        <xsl:when test="/concept">-//OASIS//DTD DITA Concept//EN</xsl:when>
        <xsl:when test="/reference">-//OASIS//DTD DITA Reference//EN</xsl:when>
        <xsl:when test="/task">-//OASIS//DTD DITA Task//EN</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="doctype">
      <xsl:choose>
        <xsl:when test="/concept">concept</xsl:when>
        <xsl:when test="/reference">reference</xsl:when>
        <xsl:when test="/task">task</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE </xsl:text>
    <xsl:value-of select="$doctype"/>
    <xsl:text disable-output-escaping='yes'> PUBLIC "</xsl:text>
    <xsl:value-of select="$doctype.public" />
    <xsl:text disable-output-escaping='yes'>" "</xsl:text>
    <xsl:value-of select="$doctype" />
    <xsl:text disable-output-escaping='yes'>.dtd"></xsl:text>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@ixia_locid"/>
  <xsl:template match="image[contains(@href, '.image')]">
    <xsl:copy>
      <xsl:attribute name="href" select="replace(@href, '.image', '.svg')"/>
      <xsl:apply-templates select="@* except (@href)|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="topicref[contains(@href, '.res')]">
    <xsl:copy>
      <xsl:attribute name="href" select="replace(@href, '.res', '.zip')"/>
      <xsl:attribute name="format" select="'zip'"/>
      <xsl:apply-templates select="@* except (@href, @format)|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>


