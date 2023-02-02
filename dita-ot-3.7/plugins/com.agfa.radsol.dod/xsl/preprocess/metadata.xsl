<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:d="http://www.docato.com" version="2.0">

  <xsl:output method="xml" encoding="utf-8" indent="yes"></xsl:output>
  
  <xsl:param name="argsInput"/>
  <xsl:param name="reviseddatefile"/>
  <xsl:param name="buildParameterLanguage"/>

  <xsl:variable name="maproot">
    <xsl:value-of select="string-join(tokenize($argsInput,'/')[position() != last()],'/')"/>
  </xsl:variable>
  
  <xsl:template match="/">
    <xsl:message>Plugin com.agfa.radsol.dod metadata.xsl preprocessing template</xsl:message>
    <xsl:message>metadata.xsl reading ditamap <xsl:value-of select="$argsInput"/></xsl:message>
    <xsl:variable name="ditamap" select="doc($argsInput)"/>
    <xsl:variable name="othermeta" select="$ditamap//othermeta"/>
    <xsl:variable name="title" select="$ditamap//mainbooktitle|//map/@title|//map/title"/>
    <xsl:variable name="documentnumber" select="($othermeta[@name='documentnumber'])[1]/@content"/>
    <xsl:message>metadata.xsl reading reviseddate from <xsl:value-of select="$reviseddatefile"/></xsl:message>
    <xsl:variable name="reviseddate" select="doc($reviseddatefile)/reviseddate/@modified"/>
    <xsl:message>metadata.xsl read reviseddate <xsl:value-of select="$reviseddate"/></xsl:message>
    <document documentnumber="{$documentnumber}" title="{$title}" lang="{$buildParameterLanguage}" reviseddate="{$reviseddate}">
      <xsl:apply-templates select="$ditamap//topicref|$ditamap//image" mode="ditamap"/>
    </document>
  </xsl:template>

  <xsl:template match="topicref" mode="ditamap">
    <topicref>
      <xsl:variable name="topicfilename" select="@href"/>
      <!-- in the published folder, english topic filenames are like s0_1417711893433.xml 
           and translated topic filenames like s0_1417711891277_00002.xml -->
      <xsl:variable name="topicid">
        <xsl:variable name="t" select="substring-after($topicfilename, '_')"/>
        <xsl:choose>
          <xsl:when test="contains($t,'_')">
            <xsl:value-of select="substring-before($t, '_')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-before($t, '.xml')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="custompropertiespath" select="concat($maproot,'/',replace($topicfilename,'.xml','.customproperties'))"/>
      <xsl:variable name="propertiespath" select="concat($maproot,'/',replace($topicfilename,'.xml','.properties'))"/>
      <xsl:variable name="topicpath" select="concat($maproot,'/',$topicfilename)"/>
      <xsl:message>metadata.xsl DEBUG maproot: <xsl:value-of select="$maproot"/>; topicfilename: <xsl:value-of select="$topicfilename"/></xsl:message>
      <topicfilename><xsl:value-of select="$topicfilename"/></topicfilename>
      <topicid><xsl:value-of select="$topicid"/></topicid>
      <authoringrevision><xsl:value-of select="doc($custompropertiespath)/customproperties/authoringRevision"/></authoringrevision>
      <reviseddate><xsl:value-of select="doc($propertiespath)/documentproperties/systemproperties/modifierinfo/date"/></reviseddate>
      <title><xsl:value-of select="doc($topicpath)/*/title"/></title>
    </topicref>
  </xsl:template>

</xsl:stylesheet>
