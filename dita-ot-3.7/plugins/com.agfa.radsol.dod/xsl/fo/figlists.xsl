<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic-mapmerge="http://www.idiominc.com/opentopic/mapmerge"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="dita-ot opentopic-mapmerge opentopic-func related-links xs"
    version="2.0">
  
    <!-- Plugin com.agfa.radsol.dod inside a fig, render ordered list item numbers in red -->
    <xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/ol ')]/*[contains(@class, ' topic/li ')]">
        <xsl:variable name="depth" select="count(ancestor::*[contains(@class, ' topic/ol ')])"/>
        <xsl:variable name="format">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="concat('Ordered List Format ', $depth)"/>
          </xsl:call-template>
        </xsl:variable>
        <fo:list-item xsl:use-attribute-sets="ol.li">
            <xsl:call-template name="commonattributes"/>
            <fo:list-item-label xsl:use-attribute-sets="ol.li__label">
                <fo:block xsl:use-attribute-sets="fig.ol.li__label__content">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="concat('Ordered List Number ', $depth)"/>
                        <xsl:with-param name="params" as="element()*">
                           <number>
                               <xsl:number format="{$format}"/>
                           </number>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body xsl:use-attribute-sets="ol.li__body">
                <fo:block xsl:use-attribute-sets="ol.li__content">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>

</xsl:stylesheet>
