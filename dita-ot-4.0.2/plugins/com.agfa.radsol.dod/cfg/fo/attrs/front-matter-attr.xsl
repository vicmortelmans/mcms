<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <xsl:attribute-set name="__frontmatter__title" use-attribute-sets="common.title">
    <!-- Plugin com.agfa.radsol.dod put the title a bit higher -->
        <xsl:attribute name="margin-top">50mm</xsl:attribute>
        <xsl:attribute name="font-family">Sans</xsl:attribute>
        <xsl:attribute name="font-size">22pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="line-height">140%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__typenumber" use-attribute-sets="common.title">
    <!-- Plugin com.agfa.radsol.dod add layout for type number -->
        <xsl:attribute name="font-family">Sans</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="line-height">140%</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>

