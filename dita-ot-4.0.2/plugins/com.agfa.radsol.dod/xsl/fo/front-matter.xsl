<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    exclude-result-prefixes="opentopic"
    version="2.0">

  <xsl:param name="buildParameterIllustration"/>

  <xsl:template name="createFrontCoverContents">
    <!-- set the title -->
    <fo:block xsl:use-attribute-sets="__frontmatter__title">
      <xsl:choose>
        <xsl:when test="$map/*[contains(@class,' topic/title ')][1]">
          <xsl:apply-templates select="$map/*[contains(@class,' topic/title ')][1]"/>
        </xsl:when>
        <xsl:when test="$map//*[contains(@class,' bookmap/mainbooktitle ')][1]">
          <xsl:apply-templates select="$map//*[contains(@class,' bookmap/mainbooktitle ')][1]"/>
        </xsl:when>
        <xsl:when test="//*[contains(@class, ' map/map ')]/@title">
          <xsl:value-of select="//*[contains(@class, ' map/map ')]/@title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/descendant::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')]"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
    <!-- set the type number -->
    <fo:block xsl:use-attribute-sets="__frontmatter__typenumber">
      <xsl:for-each select="tokenize((//*[contains(@class, ' topic/othermeta ') and @name='typenumber'])[1]/@content,',')">
        <fo:block><xsl:value-of select="."/></fo:block>
      </xsl:for-each>
    </fo:block>
    <!-- set the subtitle -->
    <xsl:if test="normalize-space((//*[contains(@class, ' topic/othermeta ') and @name='documenttype'])[1]/@content) != ''">
      <fo:block>
        <fo:leader leader-pattern="rule" leader-length="5cm"/>
      </fo:block>
      <fo:block xsl:use-attribute-sets="__frontmatter__subtitle">
        <xsl:call-template name="getVariable">
          <xsl:with-param name="id" select="concat('Subtitle ',(//*[contains(@class, ' topic/othermeta ') and @name='documenttype'])[1]/@content)"/>
        </xsl:call-template>
      </fo:block>
    </xsl:if>
    <xsl:message>Plugin com.agfa.radsol.dod front-matter.xsl template createFrontCoverContents buildParameterIllustration = "<xsl:value-of select="$buildParameterIllustration"/>" (svg file expected)</xsl:message>
    <xsl:if test="not($buildParameterIllustration = 'none')">
      <fo:block>
        <fo:external-graphic src="url('{$buildParameterIllustration}')"/>
      </fo:block>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
