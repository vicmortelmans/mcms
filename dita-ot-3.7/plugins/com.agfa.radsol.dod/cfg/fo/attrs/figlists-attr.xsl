<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <!-- Plugin com.agfa.radsol.dod numbering font style for ordered lists inside <fig> elements (matching callout font style) -->
    <xsl:attribute-set name="fig.ol.li__label__content">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="color">red</xsl:attribute>
        <xsl:attribute name="font-family">Sans</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>
