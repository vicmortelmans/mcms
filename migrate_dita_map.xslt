<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"
    doctype-public="-//OASIS//DTD DITA Map//EN"
    doctype-system="map.dtd"/>
  <!-- This transformation is run from migrate.py.
        - add DOCTYPE
        - remove @ixia_locid attributes
        - remove @keys attributes
        - rename references to resources from .res to .zip
          (the files themselves are renamed by migrate.py)
    -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@ixia_locid"/>
  <xsl:template match="@keys"/>
  <xsl:template match="topicref[contains(@href, '.res')]">
    <xsl:copy>
      <xsl:attribute name="href" select="replace(@href, '.res', '.zip')"/>
      <xsl:attribute name="format" select="'zip'"/>
      <xsl:apply-templates select="@* except (@href, @format)|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>


