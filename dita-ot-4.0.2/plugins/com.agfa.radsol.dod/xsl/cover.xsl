<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                version="2.0"
                exclude-result-prefixes="xs dita-ot ditamsg">

  <!-- Plugin com.agfa.radsol.dod build parameters defined in buildParameters.xml -->
  <xsl:param name="reviseddatefile" select="'not-set'"/><!-- this is a path -->
  <xsl:param name="buildParameterLanguage" select="'not-set'"/><!-- this is a language code like 'CS' -->
  
  <xsl:template match="*[contains(@class, ' map/map ')]/*[contains(@class, ' topic/title ')]">
    <xsl:message>Plugin com.agfa.radsol.dod cover.xsl suppressing template that generates &lt;h1&gt;</xsl:message>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' map/map ')]/@title">
    <xsl:message>Plugin com.agfa.radsol.dod cover.xsl suppressing template that generates &lt;h1&gt;</xsl:message>
  </xsl:template>

  <xsl:template name="gen-user-header">
    <xsl:apply-templates select="." mode="gen-user-header"/>
  </xsl:template>
  <xsl:template match="/|node()|@*" mode="gen-user-header">
    <xsl:message>Plugin com.agfa.radsol.dod cover.xsl new template "gen-user-header"</xsl:message>
    <header>
      <div id="logo"><img src="icons/agfa_logo_small.svg" alt="Agfa HealthCare"></img></div>
      <div id="document-title">
          <xsl:value-of select="//*[contains(@class,' bookmap/mainbooktitle ')]"/>
          <xsl:value-of select="//title[contains(@class,' topic/title ')]"/>
          <xsl:value-of select="//map/@title"/>
      </div>
      <div id="document-type">
        <xsl:call-template name="getVariable">
          <xsl:with-param name="id">
            <xsl:value-of select="concat('Subtitle ',//*[contains(@class,' topic/othermeta ')][@name = 'documenttype']/@content)"/>
          </xsl:with-param> 
        </xsl:call-template>
        <div style="clear:both;"></div>
      </div>
    </header>
  </xsl:template>

  <xsl:template name="gen-user-footer">
    <xsl:apply-templates select="." mode="gen-user-footer"/>
  </xsl:template>
  <xsl:template match="/|node()|@*" mode="gen-user-footer">
    <xsl:message>Plugin com.agfa.radsol.dod cover.xsl new template "gen-user-footer"</xsl:message>
    <footer id="document-footer">
      <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/> 
      <xsl:text> </xsl:text>
      <xsl:value-of select="$buildParameterLanguage"/>
      <xsl:text> </xsl:text>
      <xsl:message>Plugin com.agfa.radsol.dod map2html5-cover.xsl reviseddate = <xsl:value-of select="$reviseddatefile"/></xsl:message>
      <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
    </footer>
  </xsl:template>

</xsl:stylesheet>
