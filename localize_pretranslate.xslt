<?xml version="1.0"?>
<xsl:stylesheet version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Usage:
         java net.sf.saxon.Transform 
          -xsl:localize_pretranslate.xslt 
          -s:published/en-us/axk1438119593437.ditamap_59/toy1607439866732.xml 
          -o:kit/nl-nl/toy1607439866732_00059.xml 
          old-publication=published/en-us/axk1438119593437.ditamap_48/toy1607439866732.xml 
          old-translation=localization/nl-nl/toy1607439866732_00003.xml 
          language=nl-nl

         Creates a copy of the input dita file, with @xml:lang set from language param
         and with pre-translated text content, based on a mapping of old-publication to
         old-translation. 
    -->
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="old-publication"/>
  <xsl:param name="old-translation"/>
  <xsl:param name="language"/>
  <xsl:variable name="p1">
    <xsl:apply-templates select="doc($old-publication)" mode="recursive-attributes"/>
  </xsl:variable>
  <xsl:variable name="t1">
    <xsl:apply-templates select="doc($old-translation)" mode="recursive-attributes"/>
  </xsl:variable>

  <!-- mode recursive-attributes add @path and @serialization attributes to each node -->
  <xsl:template match="*" mode="recursive-attributes">
    <xsl:copy>
      <!-- https://www.saxonica.com/html/documentation10/functions/fn/index.html -->
      <xsl:attribute name="path" select="path(.)"/>
      <xsl:attribute name="serialization" select="serialize(.)"/>
      <xsl:apply-templates select="@*|node()" mode="recursive-attributes"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*|text()" mode="recursive-attributes">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- transform p2 (source) into t2 (output), using translations from t1 -->
  <xsl:template match="*">
    <!-- find (first) element with exactly the same serialization in the original source -->
    <xsl:variable name="source" select="($p1//*[@serialization = serialize(current())])[1]"/>
    <xsl:choose>
      <xsl:when test="$source">
        <!-- content has not changed! translation is found :-) -->
        <xsl:apply-templates select="$t1//*[@path = $source/@path]" mode="strip-attributes"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- content has changed; no translation found :-( -->
        <xsl:copy>
          <xsl:if test="not(@translate) and text() and normalize-space(string-join(text(),''))">
            <xsl:attribute name="translate" select="'yes'"/>
          </xsl:if>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="@xml:lang">
    <xsl:attribute name="xml:lang" select="$language"/>
  </xsl:template>
  <xsl:template match="@*|text()">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="*"/>
    </xsl:copy>
  </xsl:template>

  <!-- mode strip-attributes @path and @serialization from t1 fragments -->
  <xsl:template match="@path|@serialization" mode="strip-attributes"/>
  <xsl:template match="*" mode="strip-attributes">
    <xsl:copy>
      <xsl:if test="not(@translate) and text() and normalize-space(string-join(text(),''))">
        <xsl:attribute name="translate" select="'no'"/>
      </xsl:if>
      <xsl:apply-templates select="@*|node()" mode="strip-attributes"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*|text()" mode="strip-attributes">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="strip-attributes"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

