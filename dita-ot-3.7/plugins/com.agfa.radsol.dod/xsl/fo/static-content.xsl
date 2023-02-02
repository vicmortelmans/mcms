<?xml version='1.0'?>

<!-- com.agfa.radsol.cod TO DO I'm leaving everything in, making notes where I customize, inline and in plugin.xml, 
    so at the end I can delete the templates that aren't modified -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <xsl:param name="buildParameterLanguage" select="'not-set'"/>
    <xsl:param name="reviseddatefile" select="'not-set'"/><!-- this is a path -->

    <xsl:template name="insertBodyOddHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertBodyOddHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="odd-body-header">
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body odd header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyEvenHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertBodyEvenHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="even-body-header">
            <fo:block xsl:use-attribute-sets="__body__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body even header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFirstHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertBodyFirstHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="first-body-header">
            <fo:block xsl:use-attribute-sets="__body__first__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body first header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                          <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__first__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__body__first__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFirstFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertBodyFirstFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="first-body-footer">
            <fo:block xsl:use-attribute-sets="__body__first__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body first footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyOddFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertBodyOddFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="odd-body-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body odd footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyEvenFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertBodyEvenFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="even-body-footer">
            <fo:block xsl:use-attribute-sets="__body__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body even footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocOddHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertTocOddHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="odd-toc-header">
            <fo:block xsl:use-attribute-sets="__toc__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc odd header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__toc__odd__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocEvenHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertTocEvenHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="even-toc-header">
            <fo:block xsl:use-attribute-sets="__toc__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc even header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__toc__even__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocOddFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertTocOddFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="odd-toc-footer">
            <fo:block xsl:use-attribute-sets="__toc__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc odd footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocEvenFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertTocEvenFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="even-toc-footer">
            <fo:block xsl:use-attribute-sets="__toc__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc even footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertIndexOddHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertIndexOddHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="odd-index-header">
            <fo:block xsl:use-attribute-sets="__index__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Index odd header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__index__odd__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertIndexEvenHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertIndexEvenHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="even-index-header">
            <fo:block xsl:use-attribute-sets="__index__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Index even header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__index__even__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertIndexOddFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertIndexOddFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="odd-index-footer">
            <fo:block xsl:use-attribute-sets="__index__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Index odd footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertIndexEvenFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertIndexEvenFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="even-index-footer">
            <fo:block xsl:use-attribute-sets="__index__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Index even footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceOddHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertPrefaceOddHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="odd-body-header">
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface odd header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceEvenHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertPrefaceEvenHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="even-body-header">
            <fo:block xsl:use-attribute-sets="__body__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface even header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceFirstHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertPrefaceFirstHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="first-body-header">
            <fo:block xsl:use-attribute-sets="__body__first__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface first header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                          <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__first__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__body__first__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceFirstFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertPrefaceFirstFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="first-body-footer">
            <fo:block xsl:use-attribute-sets="__body__first__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface first footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceOddFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertPrefaceOddFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="odd-body-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface odd footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceEvenFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertPrefaceEvenFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="even-body-footer">
            <fo:block xsl:use-attribute-sets="__body__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface even footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterOddHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertFrontMatterOddHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="odd-frontmatter-header">
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface odd header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterEvenHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertFrontMatterEvenHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="even-frontmatter-header">
            <fo:block xsl:use-attribute-sets="__body__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface even header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterLastHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertFrontMatterLastHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="last-frontmatter-header">
            <fo:block xsl:use-attribute-sets="__body__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface even header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterOddFooter">
      <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl template insertFrontMatterOddFooter frontpage footer</xsl:message>
      <fo:static-content flow-name="first-frontmatter-footer"><!-- as defined in layout-masters.xsl -->
        <fo:block-container height="{$page-margin-bottom}" display-align="after" margin-left="10pt" margin-right="10pt">
          <fo:table width="100%">
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell display-align="center">
                  <fo:block text-align="left">
                    <fo:inline>
                      <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                    </fo:inline>
                    <xsl:text> </xsl:text>
                    <fo:inline>
                      <xsl:value-of select="$buildParameterLanguage"/>
                    </fo:inline>
                    <xsl:text> </xsl:text>
                    <fo:inline>
                      <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                    </fo:inline>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center">
                  <fo:block text-align="right">
                    <xsl:if test="not(//*[contains(@class, ' topic/othermeta ') and @name='whitelabel']/@content = 'true')">
                      <xsl:variable name="logoImagePath">
                        <xsl:call-template name="getVariable">
                          <xsl:with-param name="id" select="'logo Small Image Path'"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <fo:external-graphic src="url({concat($artworkPrefix, $logoImagePath)})" xsl:use-attribute-sets="image"/>
                    </xsl:if>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </fo:block-container>
      </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterEvenFooter">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertFrontMatterEvenFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="even-frontmatter-footer">
            <fo:block xsl:use-attribute-sets="__body__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface even footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>
  
    <xsl:template name="insertBackCoverOddHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertBackCoverOddHeader productName=<xsl:value-of select="$productName"/></xsl:message>
      <fo:static-content flow-name="odd-back-cover-header">
        <fo:block xsl:use-attribute-sets="__body__odd__header">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Preface odd header'"/>
            <xsl:with-param name="params">
              <prodname>
                <xsl:value-of select="$productName"/>
              </prodname>
              <heading>
                <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                  <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
              </heading>
              <pagenum>
                <fo:inline xsl:use-attribute-sets="__body__odd__header__pagenum">
                  <fo:page-number/>
                </fo:inline>
              </pagenum>
            </xsl:with-param>
          </xsl:call-template>
        </fo:block>
      </fo:static-content>
    </xsl:template>
    
    <xsl:template name="insertBackCoverEvenHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertBackCoverEvenHeader productName=<xsl:value-of select="$productName"/></xsl:message>
      <fo:static-content flow-name="even-back-cover-header">
        <fo:block xsl:use-attribute-sets="__body__even__header">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Preface even header'"/>
            <xsl:with-param name="params">
              <prodname>
                <xsl:value-of select="$productName"/>
              </prodname>
              <heading>
                <fo:inline xsl:use-attribute-sets="__body__even__header__heading">
                  <fo:retrieve-marker retrieve-class-name="current-header"/>
                </fo:inline>
              </heading>
              <pagenum>
                <fo:inline xsl:use-attribute-sets="__body__even__header__pagenum">
                  <fo:page-number/>
                </fo:inline>
              </pagenum>
            </xsl:with-param>
          </xsl:call-template>
        </fo:block>
      </fo:static-content>
    </xsl:template>
    
    <xsl:template name="insertBackCoverOddFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertBackCoverOddFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
      <fo:static-content flow-name="odd-back-cover-footer">
        <fo:block xsl:use-attribute-sets="__body__odd__footer">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Preface odd footer'"/>
            <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
            </xsl:with-param>
          </xsl:call-template>
        </fo:block>
      </fo:static-content>
    </xsl:template>
    
    <xsl:template name="insertBackCoverEvenFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertBackCoverEvenFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
      <fo:static-content flow-name="even-back-cover-footer">
        <fo:block xsl:use-attribute-sets="__body__even__footer">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Preface even footer'"/>
            <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
            </xsl:with-param>
          </xsl:call-template>
        </fo:block>
      </fo:static-content>
    </xsl:template>

    <xsl:template name="insertGlossaryOddHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertGlossaryOddHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="odd-glossary-header">
            <fo:block xsl:use-attribute-sets="__glossary__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Glossary odd header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__glossary__odd__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertGlossaryEvenHeader">
        <xsl:message>Plugin com.agfa.radsol.dod static-content.xsl insertGlossaryEvenHeader productName=<xsl:value-of select="$productName"/></xsl:message>
        <fo:static-content flow-name="even-glossary-header">
            <fo:block xsl:use-attribute-sets="__glossary__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Glossary even header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                            <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__glossary__even__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertGlossaryOddFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertGlossaryOddFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="odd-glossary-footer">
            <fo:block xsl:use-attribute-sets="__glossary__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Glossary odd footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertGlossaryEvenFooter">
        <xsl:message>Plugin com.agfa.radsol.dod insertGlossaryEvenFooter buildParameterLanguage = "<xsl:value-of select="$buildParameterLanguage"/>" reviseddatefile = "<xsl:value-of select="$reviseddatefile"/>" builddate = "<xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>"</xsl:message>
        <fo:static-content flow-name="even-glossary-footer">
            <fo:block xsl:use-attribute-sets="__glossary__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Glossary even footer'"/>
                    <xsl:with-param name="params">
                      <documentnumber>
                        <fo:inline>
                          <xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='documentnumber']/@content"/>
                        </fo:inline>
                      </documentnumber>
                      <buildlanguage>
                        <fo:inline>
                          <xsl:value-of select="$buildParameterLanguage"/>
                        </fo:inline>
                      </buildlanguage>
                      <builddate>
                        <fo:inline>
                          <xsl:value-of select="document($reviseddatefile)/reviseddate/@modified"/>
                        </fo:inline>
                      </builddate>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

</xsl:stylesheet>
