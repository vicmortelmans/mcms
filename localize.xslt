<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Usage:
         java net.sf.saxon.Transform 
          -xsl:localize.xslt 
          -s:published/en-us/axk1438119593437.ditamap_59/toy1607439866732.xml 
          -o:kit/nl-nl/toy1607439866732_00059.xml 
          language=nl-nl

         Creates a copy of the input dita file, with @xml:lang set from language param
    -->
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="language"/>
  <xsl:template match="@xml:lang">
    <xsl:attribute name="xml:lang" select="$language"/>
  </xsl:template>
  <xsl:template match="*">
    <xsl:copy>
      <xsl:if test="not(@translate) and text() and normalize-space(string-join(text(),''))">
        <xsl:attribute name="translate" select="'yes'"/>
      </xsl:if>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*|text()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

