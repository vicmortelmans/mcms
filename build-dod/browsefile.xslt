<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:d="http://www.docato.com" version="2.0"  xmlns:vars="http://www.idiominc.com/opentopic/vars">
  
  <xsl:output method="xhtml" encoding="utf-8" indent="yes"></xsl:output>
  <xsl:output name="xml" method="xml" indent="yes"/>
  <xsl:output name="properties" method="text"/>

  <xsl:param name="exportdir"/>
  <xsl:param name="templatedir"/>
  <xsl:param name="tempdir"/>
  <xsl:param name="outputdir"/><!-- not used -->
  <xsl:param name="ditadir"/>

  <xsl:variable name="metadata-with-duplicates">
    <collection>
      <xsl:copy-of select="collection(iri-to-uri(concat('file:/',$tempdir,'/?select=metadata.xml;recurse=yes')))/document"/>
    </collection>
  </xsl:variable>

  <xsl:variable name="metadata-collection">
    <xsl:apply-templates select="$metadata-with-duplicates" mode="remove-duplicate-documents-in-collection"/>
  </xsl:variable>

  <xsl:variable name="metadata">
    <xsl:for-each select="$metadata-collection/collection/document">
      <xsl:variable name="documentnumber" select="@documentnumber"/>
      <xsl:variable name="lang" select="@lang"/>
      <xsl:if test="count(preceding-sibling::*[@documentnumber = $documentnumber and @lang = $lang]) = 0">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="languages" select="document(concat('file:/',$templatedir,'/build-dod/iso639.xml'))/languages"/>

  <xsl:template match="dod">
    <xsl:message>browsefile.xslt </xsl:message>
    <xsl:variable name="name">
      <xsl:value-of select="concat(@documentId,' ',@version)"/>
    </xsl:variable>
    <xsl:variable name="isoname">
      <xsl:value-of select="concat(@documentId,'_',replace(@title,'[, ]','_'),'_',@version,'.iso')"/>
    </xsl:variable>
    <xsl:variable name="md5name">
      <xsl:value-of select="concat(@documentId,'_',replace(@title,'[, ]','_'),'_',@version,'.md5')"/>
    </xsl:variable>
    <html>
      <head>
        <title>Build output for "<xsl:value-of select="@title"/>"</title>
      </head>
      <style type="text/css">
        table { border-collapse : collapse ; margin : 10pt 0pt ; width : 100% ; }
        td { border : solid gray 1pt ; padding : 0pt 3pt ; margin : 0pt ; }
        tr.titlerow { font-weight: bold ; background-color : lightgray ; }
        td.doc { background-color : #ffeeee ; }
        td.cd { background-color : #eeffff ; }
        td.label { font-weight : bold ; }
        td.small { font-size : 8pt ; }
        td.warning { color : white ; background-color : red ; font-weight : bold ; }
        span.warning { color : red ; font-weight : bold ; }
        span.ok { color : green ; font-weight : bold ; }
        div.small { font-size : 8pt ; }
        p { margin : 0pt 3pt ; }
        .uri { padding : 0pt ; font-size : 8pt ; color : gray ; }
        .fill-in { min-height : 24pt ; border : solid gray 1pt ; padding : 3pt ; }
      </style>
      <link rel="stylesheet" type="text/css" href="https://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/css/jquery.dataTables.css"></link>
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
      <script src="https://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>
      <script type="text/javascript">
        $(document).ready(function(){
          $('.datatable').each(function(){
            $(this).dataTable(
              {
                "bPaginate": false,
              } 
            );
          });
        });
      </script>        
      <body>

        <xsl:result-document href="file:/{$tempdir}/metadata-collection.xml" format="xml">
          <xsl:copy-of select="$metadata-collection"/>
        </xsl:result-document>

        <xsl:result-document href="file:///{$tempdir}/metadata.xml" format="xml">
          <xsl:copy-of select="$metadata"/>
        </xsl:result-document>
        
        <div>
          <h1>Build Output</h1>
          <ul>
            <li><a href="{$isoname}.zip" target="_blank">Complete build output as zipped ISO-file</a></li>
            <li><a href="publication.zip" target="_blank">Complete build output as zip-file</a></li>
            <li><a href="log.txt" target="_blank">DITA-OT logfile</a></li>
            <li><a href="staging/User_Documentation/index.html">Browse build output</a></li>
            <!-- the staging path must be in sync with the parameter defined in build-dod.xml -->
          </ul>
          <h2>BUILT FOR MODULAR HELP WITH <xsl:value-of select="$ditadir"/></h2>
          <p>Following data can be copied into the Design Output Definition file:</p>
          <hr/>
          <h1>User Documentation Mapping Table</h1>
          <table>
            <tr class="titlerow">
              <td colspan="2">User Documentation Design Output</td>
            </tr>
            <tr>
              <td class="label cd">Version ID</td>
              <td class="cd"><xsl:value-of select="@documentId"/> CD <xsl:value-of select="@version"/></td>
            </tr>
            <tr>
              <td class="label cd">Title</td>
              <td class="cd"><xsl:value-of select="@title"/></td>
            </tr>
            <tr>
              <td class="label cd">Location directory on Design Output VOB</td>
              <td class="cd"></td>
            </tr>
            <tr class="titlerow">
              <td colspan="2">User Documentation Design Output Components</td>
            </tr>
            <tr>
              <td class="label cd">ISO-image filename</td>
              <td class="cd"><xsl:value-of select="$isoname"/></td>
            </tr>
            <tr>
              <td class="label cd">CD label filename</td>
              <td class="cd"><xsl:value-of select="@documentId"/> CD <xsl:value-of select="@version"/>.zip</td>
            </tr>
            <tr>
              <td class="label cd">CD box insert filename</td>
              <td class="cd"></td>
            </tr>
          </table>
          
          <table>
            <tr class="titlerow">
              <td colspan="{count($languages/language/filename) + 1}">User Documentation Design Output Languages</td>
            </tr>
            <tr>
              <td class="label cd">Language Lists</td>
              <xsl:for-each select="$languages/language/filename">
                <td class="small cd">
                  <xsl:value-of select="."/>
                </td>
              </xsl:for-each>
            </tr>
            <xsl:for-each select="//languagelist">
              <xsl:variable name="languagelist" select="."/>
              <tr>
                <td class="cd"><xsl:value-of select="@name"/></td>
                <xsl:for-each select="$languages/language/filename">
                  <td class="cd">
                    <xsl:value-of select="$languagelist/language[@code = $languages/language[filename = current()]/code]"/>
                  </td>
                </xsl:for-each>
              </tr>
            </xsl:for-each>
          </table>
          
          <table>
            <tr class="titlerow">
              <td colspan="5">User Documentation Design Output Contents</td>
            </tr>
            <tr>
              <td class="label doc">User Manual Title</td>
              <td class="label doc">User Manual Version ID</td>
              <td class="label doc">Livelink Node ID</td>
              <td class="label doc">Livelink Version</td>
              <td class="label cd">Language List</td>
            </tr>
            <xsl:for-each-group select=".//document" group-by="@documentId">
              <xsl:variable name="document">
                <xsl:choose>
                  <xsl:when test="current-group()[ancestor::language/@code = 'en_US']">
                    <xsl:copy-of select="current-group()[ancestor::language/@code = 'en_US']"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:copy-of select="current-group()[1]"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="title">
                <xsl:call-template name="title">
                  <xsl:with-param name="document" select="$document/document"/>
                </xsl:call-template>
              </xsl:variable>
              <tr>
                <td class="doc"><xsl:value-of select="$title"/></td>
                <td class="doc">
                  <xsl:value-of select="$document/document/@documentId"/>
                  <xsl:text> EN </xsl:text>
                  <xsl:variable name="reviseddate">
                    <xsl:value-of select="$metadata//document[@documentnumber = current()/@documentId][@lang = 'EN']/@reviseddate"/> 
                  </xsl:variable>
                  <xsl:value-of select="$reviseddate"/>
                  <xsl:for-each select="$metadata//document[@documentnumber = current()/@documentId][@reviseddate != $reviseddate]">
                    <div class="small">
                      (exc. in <xsl:value-of select="@lang"/>: <xsl:value-of select="@reviseddate"/>)
                    </div>
                  </xsl:for-each>
                </td>
                <td class="doc"></td>
                <td class="doc"></td>
                <td class="cd"><xsl:value-of select="$document/document/@languages"/></td>
              </tr>
            </xsl:for-each-group>
            
          </table>
          
          <h1>Translation Traceability</h1>
          
          <p>Translations that are not up-to-date are marked in red below:</p>
          
          <xsl:for-each-group select="$metadata//document" group-by="@documentnumber">
            <xsl:variable name="document" select="current-group()[@lang = 'EN']"/>
            <h2>
                <xsl:value-of select="$document/@documentnumber"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$document/@title"/>
            </h2>
            <table class="datatable">
              <thead>
                <tr>
                  <th class="label doc">Topic</th>
                  <th class="label doc">Date</th>
                  <th class="small doc">EN</th>
                  <xsl:for-each select="current-group()[@lang != 'EN']">
                    <th class="small doc"><xsl:value-of select="@lang"/></th>
                  </xsl:for-each>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="$document/topicref">
                  <xsl:sort select="reviseddate" order="descending"/>
                  <xsl:variable name="topic" select="."/>
                  <tr>
                    <td class="doc"><xsl:value-of select="title"/> (<xsl:value-of select="topicfilename"/>)</td>
                    <td class="doc"><xsl:value-of select="reviseddate"/></td>
                    <td class="doc"><xsl:value-of select="authoringrevision"/></td>
                    <xsl:for-each select="current-group()[@lang != 'EN']">
                      <!--xsl:message>DEBUG . = <xsl:copy-of select="."/></xsl:message>
                      <xsl:message>DEBUG $topic = <xsl:copy-of select="$topic"/></xsl:message-->
                      <xsl:variable name="ttopic" select="topicref[contains(topicfilename,substring-before($topic/topicfilename,'.'))]"/>
                      <!-- the above statement relies on some peculiar IXIASOFT filenaming conventions,
                           e.g. the english topic has  <topicfilename>axk1426537079175.xml</topicfilename>
                           and the BG topic has  <topicfilename>axk1426537079175_00002.xml</topicfilename> -->
                      <td class="doc">
                        <xsl:if test="not($ttopic/authoringrevision) or $topic/authoringrevision != $ttopic/authoringrevision">
                          <xsl:attribute name="class">warning</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="$ttopic/authoringrevision"/>
                      </td>
                    </xsl:for-each>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </xsl:for-each-group>
          
        </div>
        
      </body>
    </html>
    <xsl:result-document href="file:/{$tempdir}/build-dod.properties" format="properties">
      <xsl:text>isoname=</xsl:text><xsl:value-of select="$isoname"/>
      <xsl:text><!--linebreak-->
</xsl:text>
      <xsl:text>md5name=</xsl:text><xsl:value-of select="$md5name"/>
      <xsl:text><!--linebreak-->
</xsl:text>
      <xsl:text>name=</xsl:text><xsl:value-of select="$name"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="title">
    <xsl:param name="document" select="."/>
    <xsl:message>DEBUG DOCUMENT: <xsl:copy-of select="$document"/></xsl:message>
    <xsl:variable name="ditamap" select="document(concat('file:/',$exportdir,'/',$document/@ditamap))"/>
    <!--xsl:message>DEBUG DITAMAP: <xsl:copy-of select="$ditamap"/></xsl:message-->
    <xsl:value-of select="$ditamap//mainbooktitle"/>
    <xsl:value-of select="$ditamap//map/title"/>
    <xsl:value-of select="$ditamap//map/@title"/>
    <xsl:if test="normalize-space($document/@documenttype) != ''">
      <xsl:text> </xsl:text>
      <xsl:call-template name="translate">
        <xsl:with-param name="string" select="$document/@documenttype"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="translate">
    <xsl:param name="string"/>
    <xsl:if test="$string != ''">
      <xsl:variable name="vars">file:/<xsl:value-of select="$ditadir"/>/plugins/com.agfa.radsol.dod/xsl/strings-en-us.xml</xsl:variable>
      <xsl:variable name="translation">
        <xsl:value-of select="document($vars)//str[contains(@name,$string)]"/>
      </xsl:variable>
      <xsl:value-of select="$translation"/>
      <xsl:if test="not($translation)">
        <xsl:message>browsefile.xslt template "translate" ERROR no translation found for "<xsl:value-of select="$string"/>" in "<xsl:value-of select="$vars"/>"</xsl:message>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="collection" mode="remove-duplicate-documents-in-collection">
    <!-- IXIASOFT will have two metadata sets, e.g. when building for PDF and for XHTML -->
    <xsl:copy>
      <xsl:for-each-group select="document" group-by="concat(@documentnumber,@lang)">
        <xsl:apply-templates select="." mode="remove-duplicate-topicrefs-in-document"/>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="document" mode="remove-duplicate-topicrefs-in-document">
    <!-- DITA-OT1.5.1/xsl/preprocess/metadata.xsl generates metadata for each *reference* to a topic, thus e.g. duplicates for topics in the reltable -->
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each-group select="topicref" group-by="topicfilename">
        <xsl:copy-of select="."/>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
