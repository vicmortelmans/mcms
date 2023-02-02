<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    exclude-result-prefixes="dita-ot ot-placeholder opentopic opentopic-index opentopic-func dita2xslfo xs"
    version="2.0">

    <!-- Plugin com.agfa.radsol.dod fixing things that FOP crashes on -->
    <xsl:template match="@*[contains(.,'-dita-use-conref-target')]">
      <!-- removing text-align="-dita-use-conref-target", just taking out all @ with this in -->
      <xsl:message>Plugin com.agfa.radsol.dod topic.xsl template "@'-dita-use-conref-target'" attribute removed to avoid FOP crash</xsl:message>
    </xsl:template>
     
    <!-- Plugin com.agfa.radsol.dod intelligent page breaks -->
    <xsl:template match="*" mode="processTopicTitle">
        <xsl:variable name="level" as="xs:integer">
          <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>
        <xsl:variable name="number-of-topics" select="count(//*[contains(@class,' topic/topic ')])"/>
        <xsl:variable name="topic-length" select="string-length(normalize-space(..)) + 400 * count(..//*[contains(@class,' topic/image ')])"/>
        <xsl:variable name="previous-topic" select="(../preceding-sibling::*[contains(@class,' topic/topic ')])[1]"/>
        <xsl:variable name="previous-topic-length" select="string-length(normalize-space($previous-topic)) + 400 * count($previous-topic//*[contains(@class,' topic/image ')])"/>
        <xsl:message>Plugin com.agfa.radsol.dod topic.xsl template "processTopicTitle" number-of-topics=<xsl:value-of select="$number-of-topics"/>; topic-length=<xsl:value-of select="$topic-length"/>; previous-topic-length=<xsl:value-of select="$previous-topic-length"/></xsl:message>
        <xsl:variable name="attrSet1">
            <xsl:apply-templates select="." mode="createTopicAttrsName">
                <xsl:with-param name="theCounter" select="$level"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="attrSet2" select="concat($attrSet1, '__content')"/>
        <fo:block>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="$attrSet1"/>
                <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
            </xsl:call-template>
            <xsl:if test="$number-of-topics &gt; 10 and $level &gt; 1 and $level &lt; 4 and (count(../preceding-sibling::*[contains(@class,' topic/topic ')]) + count(../following-sibling::*[contains(@class,' topic/topic ')])) &gt; 0 and ((count(../preceding-sibling::*[contains(@class,' topic/topic ')]) = 0 or $previous-topic-length &gt; 500) or $topic-length &gt; 500)">
                <!-- page break for topics on levels 2 and 3, if the topic has siblings
                     and if the preceding sibling AND the topic itself both have substantial 
                     length.
                     note; this template matches the title element -->
                <xsl:attribute name="break-before">page</xsl:attribute>
            </xsl:if>
            <fo:block>
                <xsl:call-template name="processAttrSetReflection">
                    <xsl:with-param name="attrSet" select="$attrSet2"/>
                    <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                </xsl:call-template>
                <xsl:if test="$level = 1">
                    <xsl:apply-templates select="." mode="insertTopicHeaderMarker"/>
                </xsl:if>
                <xsl:if test="$level = 2">
                    <xsl:apply-templates select="." mode="insertTopicHeaderMarker">
                      <xsl:with-param name="marker-class-name" as="xs:string">current-h2</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:if>
                <fo:wrapper id="{parent::node()/@id}"/>
                <fo:wrapper>
                    <xsl:attribute name="id">
                        <xsl:call-template name="generate-toc-id">
                            <xsl:with-param name="element" select=".."/>
                        </xsl:call-template>
                    </xsl:attribute>
                </fo:wrapper>
                <xsl:apply-templates select="." mode="customTopicAnchor"/>
                <xsl:call-template name="pullPrologIndexTerms"/>
                <xsl:apply-templates select="preceding-sibling::*[contains(@class,' ditaot-d/ditaval-startprop ')]"/>
                <xsl:apply-templates select="." mode="getTitle"/>
            </fo:block>
        </fo:block>
    </xsl:template>


    <!-- Plugin com.agfa.radsol.dod admonitions with custom 'othertype' -->
    <xsl:template match="*" mode="placeNoteContent">
        <fo:block xsl:use-attribute-sets="note">
            <xsl:call-template name="commonattributes"/>
            <fo:inline xsl:use-attribute-sets="note__label">
                <xsl:choose>
                    <xsl:when test="@type='note' or not(@type)">
                        <fo:inline xsl:use-attribute-sets="note__label__note">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Note'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='notice'">
                        <fo:inline xsl:use-attribute-sets="note__label__notice">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Notice'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='tip'">
                        <fo:inline xsl:use-attribute-sets="note__label__tip">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Tip'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='fastpath'">
                        <fo:inline xsl:use-attribute-sets="note__label__fastpath">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Fastpath'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='restriction'">
                        <fo:inline xsl:use-attribute-sets="note__label__restriction">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Restriction'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='important'">
                        <fo:inline xsl:use-attribute-sets="note__label__important">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Important'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='remember'">
                        <fo:inline xsl:use-attribute-sets="note__label__remember">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Remember'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='attention'">
                        <fo:inline xsl:use-attribute-sets="note__label__attention">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Attention'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='caution'">
                        <fo:inline xsl:use-attribute-sets="note__label__caution">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Caution'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='danger'">
                        <fo:inline xsl:use-attribute-sets="note__label__danger">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Danger'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='warning'">
                        <fo:inline xsl:use-attribute-sets="note__label__danger">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Warning'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='trouble'">
                      <fo:inline xsl:use-attribute-sets="note__label__trouble">
                        <xsl:call-template name="getVariable">
                          <xsl:with-param name="id" select="'Trouble'"/>
                        </xsl:call-template>
                      </fo:inline>
                    </xsl:when>                  
                    <xsl:when test="@type='other'">
                        <fo:inline xsl:use-attribute-sets="note__label__other">
                            <xsl:choose>
                                <xsl:when test="@othertype">
                                    <xsl:message>Plugin com.agfa.radsol.dod topic.xsl template "placeNoteContent" using @othertype=<xsl:value-of select="@othertype"/> to fetch signal word</xsl:message>
                                    <xsl:variable name="lookup">
                                        <lookup>
                                            <note othertype="s4-danger" id="Danger"/>
                                            <note othertype="s3-warning" id="Warning"/>
                                            <note othertype="s2-caution" id="Caution"/>
                                            <note othertype="s1-instruction"/>
                                            <note othertype="s1-prohibition"/>
                                        </lookup>
                                    </xsl:variable>
                                    <xsl:variable name="id" select="$lookup/lookup/note[@othertype=current()/@othertype]/@id"/>  
                                    <xsl:if test="$id"> 
                                        <fo:inline xsl:use-attribute-sets="note__label__trouble">
                                          <xsl:call-template name="getVariable">
                                            <xsl:with-param name="id" select="$id"/>
                                          </xsl:call-template>
                                        </fo:inline>
                                        <xsl:call-template name="getVariable">
                                          <xsl:with-param name="id" select="'#note-separator'"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>[</xsl:text>
                                    <xsl:value-of select="@type"/>
                                    <xsl:text>]</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:inline>
                    </xsl:when>
                </xsl:choose>
                <!--xsl:call-template name="getVariable">
                  <xsl:with-param name="id" select="'#note-separator'"/>
                </xsl:call-template-->
            </fo:inline>
            <xsl:text>  </xsl:text>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/note ')]" mode="setNoteImagePath">
      <xsl:variable name="noteType" as="xs:string">
          <xsl:choose>
              <xsl:when test="@type = 'other'">
                <xsl:message>Plugin com.agfa.radsol.dod topic.xsl template "setNoteImagePath" using @othertype <xsl:value-of select="@othertype"/></xsl:message>
                  <xsl:value-of select="@othertype"/>
              </xsl:when>      
              <xsl:when test="@type">
                  <xsl:value-of select="@type"/>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:value-of select="'note'"/>
              </xsl:otherwise>
          </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="getVariable">
          <xsl:with-param name="id" select="concat($noteType, ' Note Image Path')"/>
      </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
