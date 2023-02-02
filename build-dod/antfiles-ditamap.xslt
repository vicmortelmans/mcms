<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:vars="http://www.idiominc.com/opentopic/vars">
  <xsl:output method="xml" indent="yes"/>
  <xsl:output name="xml" method="xml" indent="yes"/>
  <!--xsl:output name="properties" method="text"/-->
  <xsl:param name="ditamapbasename"/>
  <xsl:param name="ditamapdir"/>
  <xsl:param name="draft"/>
  <xsl:param name="exportdir"/>
  <xsl:param name="templatedir"/>
  <xsl:param name="plugindir"/>
  <xsl:param name="tempdir"/><!-- same as exportdir -->
  <xsl:param name="outputdir"/>
  <xsl:param name="ditadir"/>
  <xsl:param name="stagedir"/>
  <xsl:param name="languageId"/><!-- default is set in build-dod.xml -->

  <xsl:variable name="languages" select="document(concat('file:///',$templatedir,'/build-dod/iso639.xml'))/languages"/>
  <xsl:variable name="build-date" select="format-dateTime(current-dateTime(),'[Y0001][M01][D01] [H01][M01]')"/>
  <xsl:variable name="MISSINGTITLE" select="'### MISSING DITAMAP ###'"/>

  <!-- antfiles.xslt is run from build-dod.xml; 
   it takes a ditamap as input;
   it creates a DITA-OT project.xml file that will create the PDF deliverable;
    -->

  <!-- derive some global variables from the ditamap -->
  <xsl:variable name="documentId" select="//othermeta[@name = 'documentnumber']/@content"/>
  <xsl:variable name="title">
    <xsl:value-of select="//mainbooktitle"/>
    <xsl:value-of select="//map/title"/>
    <xsl:value-of select="//map/@title"/>
  </xsl:variable>
  <xsl:variable name="title-as-filename">
    <xsl:call-template name="filename">
      <xsl:with-param name="string" select="$title"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:message>antfiles.xslt param ditamapbasename <xsl:value-of select="$ditamapbasename"/></xsl:message>
    <xsl:message>antfiles.xslt param ditamapdir <xsl:value-of select="$ditamapdir"/></xsl:message>
    <xsl:message>antfiles.xslt param draft <xsl:value-of select="$draft"/></xsl:message>
    <xsl:message>antfiles.xslt param exportdir <xsl:value-of select="$exportdir"/></xsl:message>
    <xsl:message>antfiles.xslt param templatedir <xsl:value-of select="$templatedir"/></xsl:message>
    <xsl:message>antfiles.xslt param tempdir <xsl:value-of select="$tempdir"/></xsl:message>
    <xsl:message>antfiles.xslt param outputdir <xsl:value-of select="$outputdir"/></xsl:message>
    <xsl:message>antfiles.xslt param ditadir <xsl:value-of select="$ditadir"/></xsl:message>
    <xsl:message>antfiles.xslt param stagedir <xsl:value-of select="$stagedir"/></xsl:message>
    <xsl:call-template name="ahfontconfig"/>

    <xsl:result-document href="file:///{$tempdir}/project.xml" format="xml">
      <!-- these templates will create a single project.xml document for DITA-OT 3.x.x -->
      <project xmlns="https://www.dita-ot.org/project">
        <xsl:apply-templates select="map" mode="build"/>
      </project>
    </xsl:result-document>
  </xsl:template>

  <!-- template for creating a custom AH font-config.xml -->
  <xsl:template name="ahfontconfig">
    <xsl:result-document href="file:///{$tempdir}/font-config.xml">
        <font-config
            otf-metrics-mode="typographic"
            name-processing-mode="windows-name">
            <font-folder path="{$ditadir}/cfg/fonts">
          </font-folder>
          <font-folder path="C:/WINDOWS/Fonts">
          </font-folder>
        </font-config>
    </xsl:result-document>
  </xsl:template>

  

  <!-- templates for creating the build environment -->
  
  <xsl:template match="map" mode="build">
    <xsl:variable name="languagecodes">
      <xsl:call-template name="languagecodes">
        <xsl:with-param name="code">
          <xsl:choose>
            <xsl:when test="$languageId = ''">en_US</xsl:when>
            <xsl:otherwise><xsl:value-of select="$languageId"/></xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:message>antfiles.xslt: Creating build files for PDF document nr. <xsl:value-of select="$documentId"/> in <xsl:value-of select="$languagecodes/filename"/></xsl:message>
    <xsl:variable name="unique-id" select="concat($documentId, generate-id())"/>
    <xsl:variable name="build-tempdir-d" select="$tempdir"/>
    <xsl:variable name="build-stagedir-d" select="$stagedir"/>
    <xsl:variable name="file" select="concat($documentId,'-',$languagecodes/filename,'-',normalize-space($title-as-filename))"/>
    <!-- BEGIN of the PROJECT.XML deliverable -->
    <xsl:message>antfiles.xslt: Writing pdf deliverable <xsl:value-of select="$unique-id"/> to project.xml</xsl:message>
    <deliverable id="_{$unique-id}" xmlns="https://www.dita-ot.org/project"><!-- underscore, because id must not start with number -->
      <context xmlns="https://www.dita-ot.org/project">
        <input href="file:/{$ditamapdir}/{$ditamapbasename}" xmlns="https://www.dita-ot.org/project"/>
      </context>
      <output href="file:/{$build-stagedir-d}" xmlns="https://www.dita-ot.org/project"/>
      <publication transtype="pdfradsol" xmlns="https://www.dita-ot.org/project">
        <param name="clean.temp" value="no" xmlns="https://www.dita-ot.org/project"/><!-- for DEBUGGING -->
        <param name="outputFile.base" value="{$file}" xmlns="https://www.dita-ot.org/project"/>
        <param name="include.rellinks" value="parent child friend cousin ancestor descendant sample external other" xmlns="https://www.dita-ot.org/project"/>
        <param name="buildParameterIllustration" value="none" xmlns="https://www.dita-ot.org/project"/>
        <param name="buildParameterLanguage" value="{$languagecodes/filename}" xmlns="https://www.dita-ot.org/project"/>
        <param name="buildParameterDate" value="{$build-date}" xmlns="https://www.dita-ot.org/project"/>
        <param name="buildParameterBuildTempDirD" value="{$build-tempdir-d}" xmlns="https://www.dita-ot.org/project"/><!-- for writing metadata.xml -->
      </publication>
    </deliverable>
    <!-- END of the PROJECT.XML deliverable -->
  </xsl:template>
  

  <!-- UTILITY TEMPLATES -->
  
  <xsl:template name="languagecodes">
    <xsl:param name="code"/>
    <xsl:copy-of select="$languages/language[code=$code]/*"/>
  </xsl:template>

  <xsl:template name="filename">
    <xsl:param name="string"/>
    <xsl:value-of select="replace(normalize-space($string),'[^a-zA-Z0-9_-]+','-')"/>
  </xsl:template>

  <xsl:template name="translate">
    <xsl:param name="string"/>
    <xsl:param name="lang"/>
    <xsl:if test="$string != ''">
      <xsl:variable name="languagecodes">
        <xsl:call-template name="languagecodes">
          <xsl:with-param name="code">
            <xsl:value-of select="ancestor::language/@code"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="vars">file:/<xsl:value-of select="$plugindir"/>/xsl/strings-<xsl:value-of select="$languagecodes/xml"/>.xml</xsl:variable>
      <xsl:variable name="translation">
        <xsl:value-of select="document($vars)//str[contains(@name,$string)]"/>
      </xsl:variable>
      <xsl:value-of select="$translation"/>
      <xsl:if test="not($translation)">
        <xsl:message>antfiles.xslt: template "translate" ERROR no translation found for "<xsl:value-of select="$string"/>" in "<xsl:value-of select="$vars"/>"</xsl:message>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- FOR DEBUGGING -->
  
  <xsl:template match="@*|*|text()" mode="identity">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()" mode="identity"/>
    </xsl:copy>
  </xsl:template>

  
</xsl:stylesheet>
