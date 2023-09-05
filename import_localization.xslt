<?xml version="1.0"?>
<xsl:stylesheet version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Usage:
         java net.sf.saxon.Transform 
          -xsl:import_localization.xslt 
          -s:<from-translator-dir>/nl-nl/xeb1523027388384_202307141139_002.xml 
          -o:localization/nl-nl/xeb1523027388384_202307141139_002.xml 

         Creates a copy of the input dita file, with 'translate="..."' attributes removed. 
        
       Note that if the original source file had 'translate="..."' attributes, they're 
       removed as well!
    -->
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="@translate"/>
  <xsl:template match="*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*|text()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

