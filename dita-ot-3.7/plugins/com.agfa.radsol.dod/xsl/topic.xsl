<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                version="2.0"
                exclude-result-prefixes="xs dita-ot ditamsg">

  <!-- Plugin com.agfa.radsol.dod avoid empty page error when xml source contains
        illegal HTML characters -->
  <xsl:template match="text()">
    <xsl:value-of select="replace(., '[&#145;-&#149;]', ' ')"/>
  </xsl:template>


  <!-- Plugin com.agfa.radsol.dod build parameters defined in buildParameters.xml -->
  <xsl:param name="reviseddatefile" select="'not-set'"/><!-- this is a path -->
  <xsl:param name="buildParameterLanguage" select="'not-set'"/><!-- this is a language code like 'CS' -->
  <xsl:param name="buildParameterDitamap" select="'not-set'"/><!-- this is a path -->
  
  <xsl:template name="gen-user-header">
    <xsl:apply-templates select="." mode="gen-user-header"/>
  </xsl:template>
  <xsl:template match="/|node()|@*" mode="gen-user-header">
    <xsl:message>Plugin com.agfa.radsol.dod topic.xsl new template "gen-user-header"</xsl:message>
    <div id="logo"><img src="icons/agfa_logo_small.svg" alt="Agfa HealthCare"></img></div>
    <a href="index.html">
      <div id="document-title">
        <xsl:message>Plugin com.agfa.radsol.dod topic.xsl retrieving title from buildParameterDitamap = <xsl:value-of select="$buildParameterDitamap"/></xsl:message>
        <xsl:value-of select="document($buildParameterDitamap)//*[contains(@class,' bookmap/mainbooktitle ')]"/>
        <xsl:value-of select="document($buildParameterDitamap)//title[contains(@class,' topic/title ')]"/>
        <xsl:value-of select="document($buildParameterDitamap)//map/@title"/>
      </div>
      <div id="document-type">
        <xsl:call-template name="getVariable">
          <xsl:with-param name="id">
            <xsl:message>Plugin com.agfa.radsol.dod topic.xsl retrieving documenttype from buildParameterDitamap = <xsl:value-of select="$buildParameterDitamap"/></xsl:message>
            <xsl:value-of select="concat('Subtitle ',document($buildParameterDitamap)//*[contains(@class,' topic/othermeta ')][@name = 'documenttype']/@content)"/>
          </xsl:with-param> 
        </xsl:call-template>
        <div style="clear:both;"></div>
      </div>
    </a>
  </xsl:template>

  <xsl:template name="gen-user-footer">
    <xsl:apply-templates select="." mode="gen-user-footer"/>
  </xsl:template>
  <xsl:template match="/|node()|@*" mode="gen-user-footer">
    <xsl:message>Plugin com.agfa.radsol.dod topic.xsl new template "gen-user-footer"</xsl:message>
    <xsl:message>Plugin com.agfa.radsol.dod topic.xsl retrieving documentnumber from buildParameterDitamap = <xsl:value-of select="$buildParameterDitamap"/></xsl:message>
    <xsl:value-of select="document($buildParameterDitamap)//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/> 
    <xsl:text> </xsl:text>
    <xsl:value-of select="$buildParameterLanguage"/>
    <xsl:text> </xsl:text>
    <xsl:message>Plugin com.agfa.radsol.dod topic.xsl reviseddate = <xsl:value-of select="$reviseddatefile"/></xsl:message>
    <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
  </xsl:template>

  <xsl:template match="*" mode="process.note.other">
    <xsl:choose>
      <xsl:when test="@othertype">
        <xsl:message>Plugin com.agfa.radsol.dod topic.xsl template "process.note.other" for @othertype = <xsl:value-of select="@othertype"/></xsl:message>
        <div>
          <xsl:call-template name="commonattributes">
            <xsl:with-param name="default-output-class" select="string-join((@type, concat('note_', @type)), ' ')"/>
          </xsl:call-template>
          <xsl:call-template name="setidaname"/>
          <!-- Normal flags go before the generated title; revision flags only go on the content. -->
          <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop" mode="ditaval-outputflag"/>
          <table class="{@type}">
            <xsl:call-template name="commonattributes">
              <xsl:with-param name="default-output-class" select="@type"/>
            </xsl:call-template>
            <xsl:variable name="iconfile">
              <xsl:choose>
                <xsl:when test="@othertype='warning'">icons/warning.svg</xsl:when>
                <xsl:when test="@othertype='caution'">icons/caution.svg</xsl:when>
                <xsl:when test="@othertype='instruction'">icons/instruction.svg</xsl:when>
                <xsl:when test="@othertype='s1-instruction'">icons/instruction.svg</xsl:when>
                <xsl:when test="@othertype='s1-prohibition'">icons/prohibition.svg</xsl:when>
                <xsl:when test="@othertype='s2-caution'">icons/warning.svg</xsl:when>
                <xsl:when test="@othertype='s3-warning'">icons/warning.svg</xsl:when>
                <xsl:when test="@othertype='s4-danger'">icons/warning.svg</xsl:when>
                <xsl:otherwise>icons/note.svg</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <tr>
              <td>
                <img class="noteicon" src="{$iconfile}"/>
              </td>
              <td>
                <span class="{@type}title">
                  <xsl:choose>
                    <xsl:when test="@othertype='warning'">
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Warning'"/>
                      </xsl:call-template>
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'ColonSymbol'"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@othertype='caution'">
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Caution'"/>
                      </xsl:call-template>
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'ColonSymbol'"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@othertype='instruction'"></xsl:when>
                    <xsl:when test="@othertype='s1-instruction'"></xsl:when>
                    <xsl:when test="@othertype='s1-prohibition'"></xsl:when>
                    <xsl:when test="@othertype='s2-caution'">
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Caution'"/>
                      </xsl:call-template>
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'ColonSymbol'"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@othertype='s3-warning'">
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Warning'"/>
                      </xsl:call-template>
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'ColonSymbol'"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@othertype='s4-danger'">
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Danger'"/>
                      </xsl:call-template>
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'ColonSymbol'"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Note'"/>
                      </xsl:call-template>
                      <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'ColonSymbol'"/>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </span>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop" mode="ditaval-outputflag"/>
                <xsl:apply-templates/>
                <!-- Normal end flags and revision end flags both go out after the content. -->
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
              </td>
            </tr>
          </table>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="process.note.common-processing">
          <xsl:with-param name="type" select="'note'"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="process.note">
    <xsl:message>Plugin com.agfa.radsol.dod topic.xsl template "process.note"</xsl:message>
    <div>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="string-join((@type, concat('note_', @type)), ' ')"/>
      </xsl:call-template>
      <xsl:call-template name="setidaname"/>
      <!-- Normal flags go before the generated title; revision flags only go on the content. -->
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop" mode="ditaval-outputflag"/>
      <table class="{@type}">
        <xsl:call-template name="commonattributes">
          <xsl:with-param name="default-output-class" select="@type"/>
        </xsl:call-template>
        <xsl:variable name="iconfile">icons/note.svg</xsl:variable>
        <tr>
          <td>
            <img class="noteicon" src="{$iconfile}"/>
          </td>
          <td>
            <span class="{@type}title">
              <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Note'"/>
              </xsl:call-template>
              <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'ColonSymbol'"/>
              </xsl:call-template>
            </span>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop" mode="ditaval-outputflag"/>
            <xsl:apply-templates/>
            <!-- Normal end flags and revision end flags both go out after the content. -->
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
          </td>
        </tr>
      </table>
    </div>
  </xsl:template>

</xsl:stylesheet>
