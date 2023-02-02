<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Usage:
         java net.sf.saxon.Transform 
          -xsl:list_children.xslt 
          -s:authoring/toy1607439866732.ditamap 
          -o:list.txt 
          -catalog:catalog-wsl.xml

       Reads a ditamap, recursively reads all linked dita files (topicref/conref) 
       and outputs a list of all linked files (topicref/conref/image)
       Output is text, one file path per line (paths are relative to the ditamap)
    -->
  <xsl:output method="text"/>
  <xsl:template match="topicref">
    <xsl:value-of select="@href"/><xsl:text>&#13;&#10;</xsl:text>
    <xsl:if test="not(contains(@href,'.zip'))">
      <xsl:apply-templates select="document(@href)"/>
    </xsl:if>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <xsl:template match="image">
    <xsl:value-of select="@href"/><xsl:text>&#13;&#10;</xsl:text>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <xsl:template match="@conref">
    <xsl:value-of select="substring-before(.,'#')"/><xsl:text>&#13;&#10;</xsl:text>
    <xsl:apply-templates select="document(substring-before(.,'#'),/)"/>
    <!-- / makes document() search for relative path -->
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
</xsl:stylesheet>

