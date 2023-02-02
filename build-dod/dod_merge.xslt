<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>

  <!-- Called from build-dod.xml in target "dod"
        input = target DITAMAP
        output = dod_merged.xml
    -->

  <xsl:variable name="map">
  </xsl:variable>

  <xsl:template match="/map">
    <xsl:apply-templates select="/map" mode="expand-dod"/>
  </xsl:template>


  <!-- TEMPLATES FOR EXPANDING DOD RESOURCES INTO A SINGLE XML STRUCTURE -->

  <xsl:template match="topicref" mode="expand-dod">
    <expanded-reference>
      <xsl:copy-of select="document(@href)"/>
      <xsl:apply-templates mode="expand-dod"/><!-- for <mapref> inside <topicref> -->
    </expanded-reference>
  </xsl:template>
  
  <xsl:template match="topicref[@processing-role='resource-only']" mode="expand-dod"/>
    <!-- resource files should not be merged, they're not XML -->

  <xsl:template match="mapref" mode="expand-dod">
    <xsl:apply-templates select="document(@href)" mode="expand-supermap"/>
  </xsl:template>

  <xsl:template match="@*|node()" mode="expand-dod">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="expand-dod"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="mapref" mode="expand-supermap">
    <xsl:apply-templates select="document(@href)" mode="expand-ditamap-or-bookmap">
      <xsl:with-param name="href" select="@href"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="@*|node()" mode="expand-supermap">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="expand-supermap"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="expand-ditamap-or-bookmap">
    <xsl:param name="href"/>
    <xsl:copy>
      <xsl:if test="$href">
        <xsl:attribute name="href">
          <xsl:value-of select="$href"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*|node()" mode="expand-ditamap-or-bookmap"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="reltable" mode="expand-ditamap-or-bookmap">
    <xsl:apply-templates mode="expand-ditamap-or-bookmap"/>
  </xsl:template>
  
</xsl:stylesheet>
