<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:functx="http://www.functx.com" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" encoding="utf-8" indent="yes"></xsl:output>
  
  <xsl:variable name="original-ditamap-path">
    <!-- find the path to the original DITAMAP file -->
    <xsl:value-of select="/(bookmap|map)/@xtrf"/>
  </xsl:variable>
  
  <xsl:variable name="reviseddate">
    <xsl:choose>
      <xsl:when test="contains($original-ditamap-path, '/published/')">
        <!-- extract the version string from the filename of the ditamap -->
        <xsl:variable name="version-encoded" select="substring-before(substring-after($original-ditamap-path, '.ditamap_'),'/')"/>
        <xsl:call-template name="decode">
          <xsl:with-param name="str" select="replace($version-encoded,'\+',' ')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- when building a ditamap in authoring mode, generate new version string -->
        <xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001][M01][D01] [H01][m01] Authoring:work')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:template match="/">
    <xsl:message>Plugin com.agfa.radsol.dod reviseddate.xsl preprocessing template</xsl:message>
    <reviseddate>
      <xsl:attribute name="modified">
        <xsl:value-of select="$reviseddate"/>
      </xsl:attribute>
    </reviseddate>
    <xsl:message>Reviseddate: <xsl:value-of select="$reviseddate"/></xsl:message>
  </xsl:template>

  <!-- https://gist.github.com/nils-werner/721650 -->
  <xsl:variable name="hex" select="'0123456789ABCDEF'"/>
  <xsl:variable name="ascii"> !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:variable>
  <xsl:variable name="safe">!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~</xsl:variable>
  <xsl:variable name="latin1">&#160;&#161;&#162;&#163;&#164;&#165;&#166;&#167;&#168;&#169;&#170;&#171;&#172;&#173;&#174;&#175;&#176;&#177;&#178;&#179;&#180;&#181;&#182;&#183;&#184;&#185;&#186;&#187;&#188;&#189;&#190;&#191;&#192;&#193;&#194;&#195;&#196;&#197;&#198;&#199;&#200;&#201;&#202;&#203;&#204;&#205;&#206;&#207;&#208;&#209;&#210;&#211;&#212;&#213;&#214;&#215;&#216;&#217;&#218;&#219;&#220;&#221;&#222;&#223;&#224;&#225;&#226;&#227;&#228;&#229;&#230;&#231;&#232;&#233;&#234;&#235;&#236;&#237;&#238;&#239;&#240;&#241;&#242;&#243;&#244;&#245;&#246;&#247;&#248;&#249;&#250;&#251;&#252;&#253;&#254;&#255;</xsl:variable>

  <xsl:template name="decode">
    <xsl:param name="str"/>

    <xsl:choose>
      <xsl:when test="contains($str,'%')">
        <xsl:value-of select="substring-before($str,'%')"/>
        <xsl:variable name="hexpair" select="translate(substring(substring-after($str,'%'),1,2),'abcdef','ABCDEF')"/>
        <xsl:variable name="decimal" select="(string-length(substring-before($hex,substring($hexpair,1,1))))*16 + string-length(substring-before($hex,substring($hexpair,2,1)))"/>
        <xsl:choose>
          <xsl:when test="$decimal &lt; 127 and $decimal &gt; 31">
            <xsl:value-of select="substring($ascii,$decimal - 31,1)"/>
          </xsl:when>
          <xsl:when test="$decimal &gt; 159">
            <xsl:value-of select="substring($latin1,$decimal - 159,1)"/>
          </xsl:when>
          <xsl:otherwise>?</xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="decode">
          <xsl:with-param name="str" select="substring(substring-after($str,'%'),3)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
