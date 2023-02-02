<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>

  <!-- Called from build-dod.xml in target "dod"
        input = dod_merged.xml
        depends on iso639.xml in same directory
        output = dod.xml
    -->

  <xsl:variable name="languages" select="document('iso639.xml')/languages"/>

  <xsl:variable name="languagelists" select="/map/expanded-reference[1]/reference/refbody/properties[prophead/proptypehd = 'languagelist' and not(contains(prophead/propvaluehd, 'BACKUP'))]"/>
  <!-- mark language lists as e.g. "dr_BACKUP" to hide them from the build -->

  <xsl:variable name="langs">
    <xsl:for-each select="$languagelists/property[propvalue = 'X']">
      <lang code="{proptype}" list="{../prophead/propvaluehd}"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:template match="/map">
    <dod>
      <xsl:variable name="dod-metadata" select="expanded-reference[1]/reference"/>
      <xsl:attribute name="title">
        <xsl:value-of select="$dod-metadata//property[proptype='title']/propvalue/text()"/>
      </xsl:attribute>
      <xsl:attribute name="documentId">
        <xsl:value-of select="$dod-metadata//property[proptype='documentId']/propvalue/text()"/>
      </xsl:attribute>
      <xsl:attribute name="version">
        <xsl:value-of select="$dod-metadata//property[proptype='version']/propvalue/text()"/>
      </xsl:attribute>
      <xsl:attribute name="module">
        <xsl:value-of select="$dod-metadata//property[proptype='module']/propvalue/text()"/>
      </xsl:attribute>
      <xsl:attribute name="illustration">
        <xsl:value-of select="$dod-metadata//property[proptype='illustration']/propvalue/image/@href"/>
      </xsl:attribute>
      <xsl:if test=".//othermeta[@name = 'whitelabel']/@content = 'true'">
        <xsl:attribute name="whitelabel">true</xsl:attribute>
      </xsl:if>

      <xsl:variable name="map" select="."/>

      <languages>
        <xsl:for-each-group select="$langs/lang" group-by="@code">
          <xsl:variable name="code" select="current-grouping-key()"/>
          <xsl:variable name="code2" select="$languages/language[code=$code]/docato/text()"/>
          <xsl:variable name="lang" select="current-group()"/>
          <language code="{$code}">
            <documents>
              <xsl:for-each select="$map/expanded-reference[position() &gt; 1]">
                <xsl:variable name="list" select="./reference//property[proptype='languages']/propvalue/text()"/>
                <xsl:if test="$lang[@list=$list]">
                  <xsl:variable name="map" select="./map/(bookmap|map)[lower-case(@xml:lang)=$code2]"/>
                  <xsl:variable name="englishmap" select="./map/(bookmap|map)[lower-case(@xml:lang)='en-us']"/>
                  <document>
                    <xsl:attribute name="typenumber">
                      <xsl:value-of select="$map/(bookmeta|topicmeta)/othermeta[@name='typenumber']/@content"/>
                    </xsl:attribute>
                    <xsl:attribute name="documenttype">
                      <xsl:value-of select="$map/(bookmeta|topicmeta)/othermeta[@name='documenttype']/@content"/>
                    </xsl:attribute>
                    <xsl:variable name="documentId">
                      <xsl:variable name="documentId-try" select="$map/(bookmeta|topicmeta)/othermeta[@name='documentnumber']/@content"/>
                      <xsl:choose>
                        <xsl:when test="$documentId-try != ''">
                          <xsl:value-of select="$documentId-try"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:message>DOD ERROR: no documentId found, falling back to english map (if that exists)</xsl:message>
                          <xsl:value-of select="$englishmap/(bookmeta|topicmeta)/othermeta[@name='documentnumber']/@content"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="documentId">
                      <xsl:value-of select="$documentId"/>
                    </xsl:attribute>
                    <xsl:attribute name="documentNumber">
                      <xsl:value-of select="substring($documentId,1,4)"/>
                    </xsl:attribute>
                    <xsl:attribute name="ditamap">
                      <xsl:value-of select="substring-after($map/@href, '../')"/>
                      <!-- path relative to export.dir --> 
                      <xsl:if test="not($map/@href)">
                        <xsl:message>DOD ERROR: no ditamap found, maybe some translations are missing in the Supermap?</xsl:message>
                      </xsl:if>
                    </xsl:attribute>
                    <xsl:attribute name="level">
                      <xsl:value-of select="./reference//property[proptype='level']/propvalue/text()"/>
                    </xsl:attribute>
                    <xsl:attribute name="illustration">
                      <xsl:value-of select="./reference//property[proptype='illustration']/propvalue/image/@href"/>
                    </xsl:attribute>
                    <xsl:attribute name="languages">
                      <xsl:value-of select="./reference//property[proptype='languages']/propvalue/text()"/>
                    </xsl:attribute>
                    <xsl:attribute name="restrictLanguages">
                      <xsl:value-of select="./reference//property[proptype='restrictLanguages']/propvalue/text()"/>
                    </xsl:attribute>
                    <xsl:attribute name="installable">
                      <xsl:value-of select="./reference//property[proptype='installable']/propvalue/text()"/>
                    </xsl:attribute>
                    <xsl:attribute name="fileType">
                      <xsl:value-of select="./reference//property[proptype='fileType']/propvalue/text()"/>
                    </xsl:attribute>
                    <xsl:attribute name="placeholder">
                      <xsl:choose>
                        <xsl:when test="$map//topicref">no</xsl:when>
                        <xsl:otherwise>yes</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <formats>
                      <xsl:if test="./reference//property[proptype='pdf']/propvalue='X'">
                        <format name="pdf"/>
                      </xsl:if>
                      <xsl:if test="./reference//property[proptype='xhtml']/propvalue='X'">
                        <format name="xhtml"/>
                      </xsl:if>
                    </formats>
                  </document>
                </xsl:if>
              </xsl:for-each>
            </documents>
          </language>
        </xsl:for-each-group>
      </languages>

      <languagelists>
        <xsl:apply-templates select="expanded-reference[position() = 1]//properties" mode="languagelists"/>
      </languagelists>

    </dod>

  </xsl:template>

  <xsl:template match="properties[prophead/proptypehd = 'languagelist']" mode="languagelists">
    <languagelist name="{prophead/propvaluehd}">
      <xsl:apply-templates mode="languagelist"/>
    </languagelist>
  </xsl:template>
  
  <xsl:template match="property" mode="languagelist">
    <language code="{proptype}">
      <xsl:value-of select="propvalue"/>
    </language>
  </xsl:template>
  
  <xsl:template match="text()|@*" mode="languagelists"/>
  <xsl:template match="text()|@*" mode="languagelist"/>
  
</xsl:stylesheet>
