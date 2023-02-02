<!--
This file is part of the DITA Open Toolkit project.

Copyright 2006 IBM Corporation

See the accompanying LICENSE file for applicable license.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:svg="http://www.w3.org/2000/svg"
  exclude-result-prefixes="opentopic-func xs dita2xslfo dita-ot"
  version="2.0">

    <!-- Plugin com.agfa.radsol.dod 

      These templates provide a rudimentary implementation of the table-layout="auto" option
      in XSL-FO, which is not implemented in the FOP pdf renderer. By counting the number
      of characters in each cell, the total width is distributed proportionally over the 
      columns.

      The implemtation works in two phases.

      1. The template matching the <table> element calculates the total number of characters
         for each column. This is taking into account cells that span multiple rows or columns. 
         Images are accounted for as a fixed number of characters. The resulting list of
         column widths is passed to:

      2. The template matching the <colspec> element. The length is copied and provided as input
         to the XSL-FO as proportional column width. -->

    <!-- Plugin com.agfa.radsol.dod: build parameters defined in buildParameters.xml -->
    <xsl:param name="jobxmlfile" select="'not-set'"/>

    <!-- Use the hidden job file to find the path to the SVG files based on @href -->
    <xsl:variable name="job" select="document($jobxmlfile)" as="document-node()?"/>
    <xsl:key name="jobFile" match="file" use="@uri"/>


    <!-- Plugin com.agfa.radsol.dod: auxiliary templates -->
    <xsl:template name="column-number">
      <xsl:param name="entry" select="."/><!-- entry is somewhere inside the table -->
      <!-- fetches name from @colname or @namest and returns the position in colspec -->
      <xsl:variable name="colspec" select="$entry/ancestor::tgroup[1]/colspec[@colname = current()/@colname or @colname = current()/@namest]"/>
      <xsl:value-of select="count($colspec/preceding-sibling::colspec) + 1"/>
    </xsl:template>

    <xsl:template name="column-number-by-name">
      <xsl:param name="name"/>
      <!-- returns the position in colspec (current node is somewhere inside the table) -->
      <xsl:variable name="colspec" select="ancestor::tgroup[1]/colspec[@colname = $name]"/>
      <xsl:value-of select="count($colspec/preceding-sibling::colspec) + 1"/>
    </xsl:template>

    <!-- Plugin com.agfa.radsol.dod: fetch image width and height from svg and add as attributes -->
    <xsl:function name="dita-ot:normalize-length">
      <xsl:param name="l"/>
      <xsl:message>Plugin com.agfa.radsol.dod tables_fop.xsl function normalize-length of <xsl:value-of select="$l"/></xsl:message>
      <xsl:choose>
        <xsl:when test="contains($l,'cm')">
          <xsl:value-of select="round(37.8 * number(substring-before($l,'cm')))"/>
        </xsl:when>
        <xsl:when test="contains($l,'mm')">
          <xsl:value-of select="round(3.78 * number(substring-before($l,'mm')))"/>
        </xsl:when>
        <xsl:when test="contains($l,'in')">
          <xsl:value-of select="round(96.0 * number(substring-before($l,'mm')))"/>
        </xsl:when>
        <xsl:when test="contains($l,'px')">
          <xsl:value-of select="round(number(substring-before($l,'px')))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="round(number($l))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:function>


    <xsl:template match="*[contains(@class,' topic/image ')]" mode="radsol-char-eq">
      <xsl:variable name="uri" select="key('jobFile', @href, $job)/@src"/>
      <xsl:message>Plugin com.agfa.radsol.dod tables_fop.xsl template topic/image calculating char-eq for svg with @href=<xsl:value-of select="@href"/> and path="<xsl:value-of select="$uri"/> (svg path lookup using <xsl:value-of select="$jobxmlfile"/>)</xsl:message>
      <xsl:variable name="svg" select="doc($uri)/svg:svg"/>
      <xsl:message>Plugin com.agfa.radsol.dod tables-fop.xsl template topic/image loading svg with version <xsl:value-of select="$svg/@version"/></xsl:message>
      <xsl:variable name="w" select="dita-ot:normalize-length($svg/@width)"/>
      <xsl:variable name="h" select="dita-ot:normalize-length($svg/@height)"/>
      <xsl:variable name="s" select="$w * $h"/>
      <xsl:variable name="c" select="round($w div 5.6 * $h div 15.6)"/>
    <!-- w and h factors are based on my own measurement that in a result PDF, 
         horizontally characters take 5.6px and
         vertically characters (lines) take 15.6px -->
      <xsl:message>Plugin com.agfa.radsol.dod tables-fop.xsl template topic/image calculated image width="<xsl:value-of select="$w"/>" height="<xsl:value-of select="$h"/>" surface="<xsl:value-of select="$s"/>" char-eq="<xsl:value-of select="$c"/>"</xsl:message> 
      <image href="{@href}" char-eq="{$c}"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/table ')]">
      <!-- FIXME, empty value -->
        <xsl:variable name="scale" as="xs:string?">
            <xsl:call-template name="getTableScale"/>
        </xsl:variable>

        <!-- Plugin com.agfa.radsol.dod: create a list with for each image an equivalent number of characters (taking approximately the same space) -->
        <xsl:variable name="image-char-eq">
          <xsl:apply-templates select=".//*[contains(@class,' topic/image ')]" mode="radsol-char-eq"/>
        </xsl:variable>

        <!-- Plugin com.agfa.radsol.dod: create a list with length specs for all table entries (spans expanded!) -->
        <xsl:variable name="total-table-length" select="string-length(normalize-space(string(.))) + sum($image-char-eq//@char-eq)"/>
        <xsl:variable name="average-column-length" select="floor($total-table-length div count(tgroup/colspec))"/>
        <xsl:variable name="entry-lengths">
          <!-- this variable contains an 'expanded' table grid in which merged entries are
          un-merged ; each entry contains the number of characters that are attributed
          to the entry ; for images a 'character equivalent' value is accounted for. -->
          <xsl:for-each select="tgroup/*/row">
            <xsl:variable name="row-position"><xsl:number/></xsl:variable>
            <xsl:for-each select="entry">
              <xsl:variable name="entry" select="."/>
              <!-- if entry spans rows, calculate the row number where it ends -->
              <xsl:variable name="row-end-position">
                <xsl:choose>
                  <xsl:when test="@morerows"><xsl:value-of select="$row-position + @morerows"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$row-position"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable> 
              <!-- calculate current col number -->
              <xsl:variable name="col-position">
                <xsl:call-template name="column-number"/>
              </xsl:variable>
              <!-- if entry spans cols, calculate the col number where it ends -->
              <xsl:variable name="col-end-position">
                <xsl:choose>
                  <xsl:when test="@namest">
                    <xsl:call-template name="column-number-by-name">
                      <xsl:with-param name="name" select="@nameend"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise><xsl:value-of select="$col-position"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <!-- calculate the total number of spanned cells -->
              <xsl:variable name="divider" select="($col-end-position - $col-position + 1) * ($row-end-position - $row-position + 1)"/>
              <!-- calculate the number of characters to be fitted into the expanded cells -->
              <xsl:variable name="length">
                <!-- an image is accounted for based on the calculated 'character equivalent' -->
                <xsl:value-of select="floor((string-length(normalize-space(string(.))) + sum($image-char-eq/image[@href = current()//image/@href]/@char-eq)) div $divider)"/>
              </xsl:variable>
              <!-- construct the list of (expanded) entries; it's a flat list of entries,
                   with @col-number and @row-position as coordinates and the length as value -->
              <xsl:for-each select="(ancestor::tgroup[1]/*/row)[position() &gt;= $row-position and position() &lt;= $row-end-position]">
                <xsl:variable name="row-expanded-position" select="$row-position + position() - 1"/>
                <xsl:for-each select="ancestor::tgroup[1]/colspec[position() &gt;= $col-position and position() &lt;= $col-end-position]">
                  <xsl:variable name="col-expanded-position" select="$col-position + position() - 1"/>
                  <entry col-number="{$col-expanded-position}" row-number="{$row-expanded-position}">
                    <xsl:value-of select="$length"/>
                    <xsl:message>DEBUG entry <xsl:value-of select="$col-expanded-position"/>, row <xsl:value-of select="$row-expanded-position"/>, length <xsl:value-of select="$length"/></xsl:message>
                    <xsl:if test="$length = 0 and $entry">
                      <xsl:message>Plugin com.agfa.radsol tables_fop.xsl template table WARNING table cell with actual content and calculated length 0: "<xsl:copy-of select="$entry"/>"</xsl:message>
                    </xsl:if>
                  </entry>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:for-each><!-- entry in original table -->
          </xsl:for-each><!-- row in the original table -->
        </xsl:variable><!-- entry-lengths -->

        <xsl:message>Plugin com.agfa.radsol tables_fop.xsl template table created list of lengths <xsl:value-of select="string-join($entry-lengths,',')"/></xsl:message>
        <!-- Plugin com.agfa.radsol.dod: accumulate the lengths for each column -->
        <xsl:variable name="col-lengths">
          <xsl:for-each select="tgroup/colspec">
            <xsl:variable name="col-position"><xsl:number/></xsl:variable>
            <xsl:message>DEBUG colspec <xsl:value-of select="$col-position"/></xsl:message>
            <colspec colname="{@colname}">
              <xsl:variable name="averaged-length">
                <!-- to avoid cols that too narrow or too wide, the length is 'averaged with the average length' -->
                <xsl:value-of select="floor((sum($entry-lengths//entry[@col-number = $col-position]) + $average-column-length) div 2)"/>
              </xsl:variable>
              <xsl:message>DEBUG length <xsl:value-of select="$averaged-length"/></xsl:message>
              <xsl:attribute name="total-length" select="$averaged-length"/>
            </colspec>
          </xsl:for-each>
        </xsl:variable>
        <xsl:message>Plugin com.agfa.radsol tables_fop.xsl template table calculated col-lengths <xsl:copy-of select="$col-lengths"/></xsl:message>


        <fo:block-container xsl:use-attribute-sets="table__container">
            <fo:block xsl:use-attribute-sets="table">
                <xsl:call-template name="commonattributes"/>
                <xsl:if test="not(@id)">
                  <xsl:attribute name="id">
                    <xsl:call-template name="get-id"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="exists($scale)">
                    <xsl:attribute name="font-size" select="concat($scale, '%')"/>
                </xsl:if>
                <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
                <xsl:apply-templates>
                  <!-- Plugin com.agfa.radsol.dod: pass col-lengths through a tunnel towards the colspec template -->
                  <xsl:with-param name="col-lengths" select="$col-lengths" tunnel="yes"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
            </fo:block>
        </fo:block-container>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/colspec ')]">
      <!-- Plugin com.agfa.radsol.dod: receive lengths table -->
      <xsl:param name="col-lengths" tunnel="yes"/>
      <xsl:message>Plugin com.agfa.radsol tables_fop.xsl template colspec "<xsl:value-of select="@colname"/>" using col-lengths <xsl:copy-of select="$col-lengths"/></xsl:message>
      <xsl:variable name="total-length">
        <xsl:choose>
          <xsl:when test="count($col-lengths/colspec[@colname = current()/@colname]) &gt; 1">
            <xsl:message>Plugin com.agfa.radsol tables_fop.xsl template colspec ERROR colname inconsistency in <xsl:value-of select="ancestor::*[contains(@class, ' topic/topic ')][1]/@oid"/></xsl:message>
            <xsl:value-of select="($col-lengths/colspec[@colname = current()/@colname])/@total-length"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$col-lengths/colspec[@colname = current()/@colname]/@total-length"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <fo:table-column>
        <xsl:attribute name="column-number" select="@colnum"/>
        <!-- Plugin com.agfa.radsol.dod: use value from lengths table -->
        <xsl:attribute name="column-width">
          <xsl:message>Plugin com.agfa.radsol.dod tables_fop.xsl template colspec using calculated colwidth <xsl:value-of select="$total-length"/></xsl:message>
          <xsl:call-template name="calculateColumnWidth.Proportional">
            <xsl:with-param name="colwidth" select="concat($total-length, '*')"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:call-template name="applyAlignAttrs"/>
      </fo:table-column>
    </xsl:template>

</xsl:stylesheet>
