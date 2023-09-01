<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:vars="http://www.idiominc.com/opentopic/vars" xmlns:rds="http://www.agfa.com">
  <xsl:output method="xml" indent="yes"/>
  <xsl:output name="xml" method="xml" indent="yes"/>
  <xsl:output name="html" method="html" indent="yes"/>
  <xsl:output name="text" method="text"/>
  <!--xsl:output name="properties" method="text"/-->
  <xsl:param name="ditamapbasename"/>
  <xsl:param name="ditamapdir"/>
  <xsl:param name="draft"/>
  <xsl:param name="exportdir"/>
  <xsl:param name="templatedir"/>
  <xsl:param name="plugindir"/>
  <xsl:param name="tempdir"/><!-- same as exportdir -->
  <xsl:param name="outputdir"/>
  <xsl:param name="ditadir"/>
  <xsl:param name="stagedir"/>

  <xsl:variable name="languages" select="document(concat('file:///',$templatedir,'/build-dod/iso639.xml'))/languages"/>
  <xsl:variable name="build-date" select="format-dateTime(current-dateTime(),'[Y0001][M01][D01] [H01][M01]')"/>
  <xsl:variable name="MISSINGTITLE" select="'### MISSING DITAMAP ###'"/>

  <xsl:template match="/">
    <xsl:message>antfiles.xslt param ditamapbasename <xsl:value-of select="$ditamapbasename"/></xsl:message>
    <xsl:message>antfiles.xslt param ditamapdir <xsl:value-of select="$ditamapdir"/></xsl:message>
    <xsl:message>antfiles.xslt param draft <xsl:value-of select="$draft"/></xsl:message>
    <xsl:message>antfiles.xslt param exportdir <xsl:value-of select="$exportdir"/></xsl:message>
    <xsl:message>antfiles.xslt param templatedir <xsl:value-of select="$templatedir"/></xsl:message>
    <xsl:message>antfiles.xslt param tempdir <xsl:value-of select="$tempdir"/></xsl:message>
    <xsl:message>antfiles.xslt param outputdir <xsl:value-of select="$outputdir"/></xsl:message>
    <xsl:message>antfiles.xslt param ditadir <xsl:value-of select="$ditadir"/></xsl:message>
    <xsl:message>antfiles.xslt param stagedir <xsl:value-of select="$stagedir"/></xsl:message>
    <xsl:message>antfiles.xslt -- modular help</xsl:message>
    <xsl:call-template name="ahfontconfig"/>

    <!--xsl:apply-templates select="/" mode="browse"/-->
    
    <!-- antfiles.xslt is run from build-dod.xml; 
     it takes dod.xml as input;
     it creates ANT build.xml files for staging placeholder documents and images;
     it creates a single DITA-OT project.xml file that will create the PDF/HTML deliverables;
     it creates navigation files that are part of the CD;
      -->

    <xsl:variable name="dod-with-untranslated-docs">
      <xsl:apply-templates select="/" mode="add-untranslated"/>
    </xsl:variable>
    
    <xsl:result-document href="file:///{$tempdir}/dod-with-untranslated-docs.xml" format="xml">
      <xsl:apply-templates select="$dod-with-untranslated-docs" mode="identity"/>
    </xsl:result-document>

    <xsl:result-document href="file:///{$tempdir}/project.xml" format="xml">
      <!-- these templates will create build.xml documents for each deliverable (will become obsolete),
           but is now also producing a single project.xml document for DITA-OT 3.5.3 -->
      <xsl:apply-templates select="$dod-with-untranslated-docs" mode="build"/>
    </xsl:result-document>
    <xsl:apply-templates select="$dod-with-untranslated-docs" mode="navigate"/>
  </xsl:template>

  <!-- template for creating a custom AH font-config.xml -->
  <xsl:template name="ahfontconfig">
    <xsl:result-document href="file:///{$tempdir}/font-config.xml">
        <font-config
            otf-metrics-mode="typographic"
            name-processing-mode="windows-name">
            <font-folder path="{$ditadir}/cfg/fonts">
          </font-folder>
          <font-folder path="C:/WINDOWS/Fonts">
          </font-folder>
        </font-config>
    </xsl:result-document>
  </xsl:template>

  

  <!-- templates for adding for the untranslated documents references to the english documents -->
  
  <xsl:template match="@*|node()" mode="add-untranslated">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="add-untranslated"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="documents"  mode="add-untranslated">
    <xsl:copy>
      <xsl:apply-templates select="@*|*" mode="add-untranslated"/>
      <xsl:variable name="documents" select="."/>
      <xsl:for-each select="ancestor::dod/languages/language[@code='en_US']/documents/document">
        <xsl:if test="not($documents/document[@documentId=current()/@documentId]) and not(@restrictLanguages='yes')">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="language">untranslated</xsl:attribute>
            <xsl:apply-templates mode="add-untranslated"/>
          </xsl:copy>
        </xsl:if>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <!-- templates for creating the build environment -->
  
  <xsl:template match="dod" mode="build">
    <project xmlns="https://www.dita-ot.org/project">
      <xsl:apply-templates select="languages/language" mode="build"/>
    </project>
  </xsl:template>

  <xsl:template match="languages/language" mode="build">
    <xsl:message>anfiles.xslt: Rendering language <xsl:value-of select="@code"/></xsl:message>
    <xsl:message>anfiles.xslt: In <xsl:value-of select="$tempdir"/></xsl:message>
    <xsl:apply-templates select=".//format" mode="build">
      <xsl:with-param name="languagecodes">
        <xsl:call-template name="languagecodes">
          <xsl:with-param name="code" select="@code"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="englishlanguagecodes">
        <xsl:call-template name="languagecodes">
          <xsl:with-param name="code" select="'en_US'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="format[@name='pdf']" mode="build">
    <xsl:param name="languagecodes"/>
    <xsl:param name="englishlanguagecodes"/>
    <xsl:variable name="d" select="ancestor::document"/>
    <xsl:variable name="ditamapbasename" select="$d/@ditamap"/>
    <xsl:variable name="installable" select="$d/@installable"/>
    <xsl:variable name="dod-title-slug">
      <xsl:call-template name="string-to-slug">
        <xsl:with-param name="text" select="ancestor::dod/@title"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="dod-id" select="ancestor::dod/@documentId"/>
    <xsl:message>antfiles.xslt: Creating build files for PDF document nr. <xsl:value-of select="$d/@documentId"/> in <xsl:value-of select="$languagecodes/filename"/> based on "<xsl:value-of select="$ditamapbasename"/>"</xsl:message>
    <xsl:choose>
      <xsl:when test="$ditamapbasename= ''">
	<xsl:message>antfiles.xslt: ERROR MISSING DITAMAP - no build files will be created<xsl:value-of select="error(QName(namespace-uri(),name()), 'ERROR: MISSING DITAMAP')"/></xsl:message>
      </xsl:when>
      <xsl:when test="$d/@language = 'untranslated'">
        <xsl:message>antfiles.xslt: untranslated map - no build files will be created</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="unique-id" select="concat($d/@documentId, generate-id())"/>
        <xsl:variable name="build-tempdir-d" select="concat($tempdir,'/',$languagecodes/filename,'/pdf/',$unique-id)"/>
        <xsl:variable name="non-xdoc-solution-folder">
          <xsl:choose>
            <xsl:when test="$dod-id = 'XDOC'">
              <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($dod-title-slug,'/')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="build-stagedir-d">
          <xsl:choose>
            <xsl:when test="$installable='yes'">
              <xsl:value-of select="concat($stagedir,'/Install_Online_Help_on_NX/',$languagecodes/filename,'/',$non-xdoc-solution-folder)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($stagedir,'/User_Documentation/',$languagecodes/filename)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="navigation-illustration-stagedir-d"><!-- just for making sure the illustration is copied into User_Documentation as well, e.g. in case of installable pdf placeholder -->
          <xsl:choose>
            <xsl:when test="$installable='yes'">
              <xsl:value-of select="concat($stagedir,'/User_Documentation/',$languagecodes/filename)"/>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="title">
          <xsl:call-template name="filename">
            <xsl:with-param name="string">
              <xsl:call-template name="englishtitle">
                <xsl:with-param name="document" select="$d"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="title-as-filename">
          <xsl:call-template name="filename">
            <xsl:with-param name="string" select="$title"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="file" select="concat($d/@documentId,'-',$languagecodes/filename,'-',normalize-space($title-as-filename))"/>
        <xsl:variable name="antfile">
          <xsl:value-of select="concat('file:///',$build-tempdir-d,'/build.xml')"/>
        </xsl:variable>
        <xsl:variable name="documentVersion" select="substring($d/@documentId,5,1)"/>
        <xsl:message>antfiles.xslt: Creating build file (<xsl:value-of select="$antfile"/>) for building <xsl:value-of select="concat($build-stagedir-d,'/pdf/',$file,'.pdf')"/> (placeholder or auxiliary files)</xsl:message>
        <xsl:result-document href="{$antfile}" format="xml">
          <!-- BEGIN of the ANT file -->
          <project name="DO" default="do"  basedir=".">
            <!-- following properties are used by imported targets ! -->
            <property name="tempdir" value="{$tempdir}"/>
            <property name="template.dir" value="{$templatedir}"/>
            <property name="stagedir" value="{$stagedir}"/>
            <property name="ditamapbasename" value="{$ditamapbasename}"/>
            <!--import file="{$templatedir}/build-dod-import.xml"/-->
            <target name="do" depends="illustration,img">
              <record name="{$build-tempdir-d}/build.log" loglevel="verbose" append="false"/>
              <xsl:if test="$d/@placeholder = 'yes'">
                <echo message="build.xml {$file} do: Copying placeholder document"/>
                <xsl:variable name="fileType">
                  <xsl:choose>
                    <xsl:when test="$d/@fileType != ''">
                      <xsl:value-of select="$d/@fileType"/>
                    </xsl:when>
                    <xsl:otherwise>pdf</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <copy todir="{$build-stagedir-d}/pdf/">
                  <fileset dir="{$tempdir}/placeholders">
                    <include name="*{$d/@documentNumber}*{$documentVersion}*{$languagecodes/filename}*.*"/>
                    <exclude name="*.zip"/><!-- for if the zip filename happens to match above pattern -->
                  </fileset>
                  <mapper type="merge" to="{$file}.{$fileType}"/>
                </copy>
              </xsl:if>
            </target>
            <target  name="illustration">
              <xsl:if test="$d/@illustration != ''">
                <echo message="build.xml {$file} illustration: Copying illustration"/>
                <mkdir dir="{concat($build-stagedir-d,'/illustrations')}"/>
                <copy failonerror="false"
                  file="{concat($ditamapdir,'/',$d/@illustration)}" 
                  tofile="{concat($build-stagedir-d,'\illustrations\',$d/@illustration)}"/>
                <xsl:if test="$navigation-illustration-stagedir-d">
                  <copy failonerror="false"
                    file="{concat($ditamapdir,'/',$d/@illustration)}" 
                    tofile="{concat($navigation-illustration-stagedir-d,'\illustrations\',$d/@illustration)}"/>
                </xsl:if>
              </xsl:if>
            </target>
            <target name="img">
              <!-- this should actually only be done once per language, but there's no build file on language level, so it's done over and over -->
              <echo message="build.xml {$file} img: Copying img"/>
              <copy failonerror="false"
                todir="{concat($build-stagedir-d,'\img')}">
                <fileset dir="{concat($stagedir,'\User_Documentation\img')}"/>
              </copy>
            </target>
            <target name="clean">
              <echo message="build.xml {$file} clean: Cleaning dirs"/>
              <delete includeemptydirs="true" quiet="false" failonerror="false">
                <fileset dir="{$build-tempdir-d}"/>
                <fileset dir="{$build-stagedir-d}\pdf\"/>
              </delete>
            </target>
          </project>
          <!-- END of the ANT file -->
        </xsl:result-document>
        <!-- BEGIN of the PROJECT.XML deliverable -->
        <xsl:if test="not($d/@placeholder = 'yes')">
          <xsl:message>antfiles.xslt: Writing pdf deliverable <xsl:value-of select="$unique-id"/> to project.xml</xsl:message>
          <deliverable id="_{$unique-id}" xmlns="https://www.dita-ot.org/project"><!-- underscore, because id must not start with number -->
            <context xmlns="https://www.dita-ot.org/project">
              <input href="file:/{$exportdir}/{$ditamapbasename}" xmlns="https://www.dita-ot.org/project"/>
            </context>
            <output href="file:/{$build-stagedir-d}/pdf" xmlns="https://www.dita-ot.org/project"/>
            <publication transtype="pdfradsol" xmlns="https://www.dita-ot.org/project">
              <param name="clean.temp" value="no" xmlns="https://www.dita-ot.org/project"/><!-- for DEBUGGING -->
              <param name="dita.temp.dir" value="{$build-tempdir-d}" xmlns="https://www.dita-ot.org/project"/>
              <param name="outputFile.base" value="{$file}" xmlns="https://www.dita-ot.org/project"/>
              <param name="include.rellinks" value="parent child friend cousin ancestor descendant sample external other" xmlns="https://www.dita-ot.org/project"/>
              <xsl:choose>
                <xsl:when test="$d/@illustration != ''">
                  <param name="buildParameterIllustration" value="file:/{$ditamapdir}/{$d/@illustration}" xmlns="https://www.dita-ot.org/project"/>
                </xsl:when>
                <xsl:otherwise>
                  <param name="buildParameterIllustration" value="none" xmlns="https://www.dita-ot.org/project"/>
                </xsl:otherwise>
              </xsl:choose>
              <param name="buildParameterLanguage" value="{$languagecodes/filename}" xmlns="https://www.dita-ot.org/project"/>
              <param name="buildParameterDate" value="{$build-date}" xmlns="https://www.dita-ot.org/project"/>
              <param name="buildParameterBuildTempDirD" value="{$build-tempdir-d}" xmlns="https://www.dita-ot.org/project"/><!-- for writing metadata.xml -->
            </publication>
          </deliverable>
        </xsl:if>    
        <!-- END of the PROJECT.XML deliverable -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="format[@name='xhtml']" mode="build">
    <xsl:param name="languagecodes"/>
    <xsl:variable name="d" select="ancestor::document"/>
    <xsl:variable name="installable" select="$d/@installable"/>
    <xsl:variable name="dod-title-slug">
      <xsl:call-template name="string-to-slug">
        <xsl:with-param name="text" select="ancestor::dod/@title"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lang">
      <xsl:choose>
        <xsl:when test="$d/@language='untranslated'">EN</xsl:when>
        <xsl:otherwise><xsl:value-of select="$languagecodes/filename"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="dod-id" select="ancestor::dod/@documentId"/>
    <xsl:variable name="doc-id" select="$d/@documentId"/>
    <xsl:message>antfiles.xslt: Creating build files for XHTML documents</xsl:message>
    <xsl:choose>
      <xsl:when test="$d/@language = 'untranslated'">
        <xsl:message>antfiles.xslt: untranslated map - no build files will be created</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="unique-id" select="concat($doc-id, generate-id())"/>
        <xsl:variable name="file" select="concat($doc-id,'-',$lang)"/>
        <xsl:variable name="build-tempdir-d" select="concat($tempdir,'/',$lang,'/html/',$doc-id,'-',$lang)"/>
        <xsl:variable name="dita-ot-tempdir-d" select="concat($tempdir,'/',$lang,'/html-dita-ot/',$doc-id,'-',$lang)"/>
        <xsl:variable name="non-xdoc-solution-folder">
          <xsl:choose>
            <xsl:when test="$dod-id = 'XDOC'">
              <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($dod-title-slug,'/')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="build-base-stagedir-d">
          <xsl:choose>
            <xsl:when test="$installable='no'">
              <xsl:value-of select="concat($stagedir,'/User_Documentation/',$lang,'/')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($stagedir,'/Install_Online_Help_on_NX/',$lang,'/',$non-xdoc-solution-folder,'/')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="navigation-illustration-stagedir-d"><!-- just for making sure the illustration is copied into User_Documentation as well, e.g. in case of installable pdf placeholder -->
          <xsl:choose>
            <xsl:when test="$installable='yes'">
              <xsl:value-of select="concat($stagedir,'/User_Documentation/',$languagecodes/filename)"/>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="build-stagedir-d">
          <xsl:value-of select="concat($build-base-stagedir-d,'html/',$doc-id,'-',$lang)"/>
        </xsl:variable>
        <xsl:variable name="relative-link-from-search-html-d">
          <xsl:choose>
            <xsl:when test="$dod-id = 'XDOC'">
              <xsl:value-of select="concat('html/',$doc-id,'-',$lang)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('../../Modules/',$lang,'/',$non-xdoc-solution-folder,'html/',$doc-id,'-',$lang)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ditamapbasename" select="$d/@ditamap"/>
        <xsl:variable name="antfile">
          <xsl:value-of select="concat('file:///',$build-tempdir-d,'/build.xml')"/>
        </xsl:variable>
        <xsl:message>antfiles.xslt: Creating build file (<xsl:value-of select="$antfile"/>) for building <xsl:value-of select="$build-stagedir-d"/></xsl:message>
        <xsl:result-document href="{$antfile}" format="xml">
          <!-- BEGIN of the ANT file -->
          <project name="DO" default="do"  basedir=".">
            <!-- following properties are used by imported targets ! -->
            <property name="tempdir" value="{$tempdir}"/>
            <property name="template.dir" value="{$templatedir}"/>
            <property name="stagedir" value="{$stagedir}"/>
            <property name="ditamapbasename" value="{$ditamapbasename}"/>
            <!--import file="{$templatedir}\build-dod-import.xml"/-->
            <target name="do" depends="illustration,img,icons,installer,search">
              <record name="{$build-tempdir-d}\build.log" loglevel="verbose" append="false"/>
              <xsl:if test="$d/@placeholder = 'yes'">
                <echo message="build.xml {$file} do: HTML Placeholders not supported"/>
              </xsl:if>
            </target>
            <target  name="illustration">
              <xsl:if test="$d/@illustration != ''">
                <echo message="build.xml {$file} illustration: Copying illustration"/>
                <mkdir dir="{concat($stagedir,'/Install_Online_Help_on_NX/',$lang,'/',$non-xdoc-solution-folder,'illustrations')}"/>
                <copy failonerror="false"
                  file="{concat($ditamapdir,'/',$d/@illustration)}" 
                  tofile="{concat($build-base-stagedir-d,'illustrations/',$d/@illustration)}"/>
              </xsl:if>
            </target>
            <target name="img">
              <!-- this should actually only be done once per language, but there's no build file on language level, so it's done over and over (only when html is built) -->
              <echo message="build.xml {$file} img: Copying img"/>
              <copy failonerror="false"
                todir="{concat($build-base-stagedir-d,'img')}">
                <fileset dir="{concat($stagedir,'/User_Documentation/img')}"/>
              </copy>
            </target>
            <target name="icons">
              <!-- note icons are not copied by DITA, so they're inserted via Ant -->
              <echo message="build.xml {$file} icons: Copying icons"/>
              <copy file="{$plugindir}/cfg/common/artwork/caution.svg" todir="{$build-stagedir-d}\icons"/>
              <copy file="{$plugindir}/cfg/common/artwork/warning.svg" todir="{$build-stagedir-d}\icons"/>
              <copy file="{$plugindir}/cfg/common/artwork/instruction.svg" todir="{$build-stagedir-d}\icons"/>
              <copy file="{$plugindir}/cfg/common/artwork/note.svg" todir="{$build-stagedir-d}\icons"/>
              <copy file="{$plugindir}/cfg/common/artwork/prohibition.svg" todir="{$build-stagedir-d}\icons"/>
              <copy file="{$plugindir}/cfg/common/artwork/agfa_logo_small.svg" todir="{$build-stagedir-d}\icons"/>
            </target> 
            <target name="installer">
              <xsl:message>DEBUG going to test <xsl:value-of select="$installable"/></xsl:message>
              <xsl:if test="not(ancestor::dod/@module and $installable='no')">
                <xsl:message>DEBUG tested <xsl:value-of select="$installable"/> not to be 'no'</xsl:message>
                <!-- this should actually only be done once, but there's no build file on global level, so it's done over and over (only when installables are built) -->
                <echo message="build.xml {$file} installer: Moving installer files"/>
                <xsl:choose>
                  <xsl:when test="$dod-id = 'XDOC'">
                    <move failonerror="false"
                      file="{concat($stagedir,'/OnlineHelp.exe')}"
                      tofile="{concat($stagedir,'/Install_Online_Help_on_NX/Install Online Help.exe')}"/>
                    <delete failonerror="false"
                      file="{concat($stagedir,'/ModuleOnlineHelp.exe')}"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <move failonerror="false"
                      file="{concat($stagedir,'/ModuleOnlineHelp.exe')}"
                      tofile="{concat($stagedir,'/Install_Online_Help_on_NX/Install Online Help.exe')}"/>
                    <delete failonerror="false"
                      file="{concat($stagedir,'/OnlineHelp.exe')}"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </target>
            <target name="search">
              <!-- generate the index file search.js for this manual -->
              <echo message="build.xml {$file} search: Building index search.js"/>
              <exec executable="node">
                <arg value="{$templatedir}/build-dod/lunrjs/build-index.js"/>
                <arg value="{$build-stagedir-d}"/>
                <arg value="{$relative-link-from-search-html-d}"/>
                <arg value="{$lang}"/>
              </exec>
              <xsl:message>DEBUG going to test <xsl:value-of select="$installable"/></xsl:message>
              <xsl:if test="not(ancestor::dod/@module='') and not($installable='no')">
                <!-- concatenate search.js onto searchxxx.js (xxx = module number) -->
                <xsl:message>DEBUG tested <xsl:value-of select="$installable"/> not to be 'no'</xsl:message>
                <xsl:variable name="search-filename">
                  <xsl:choose>
                    <xsl:when test="$dod-id='XDOC'">
                      <xsl:text>searchxdoc.js</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>          
                      <xsl:value-of select="concat('search',format-number(ancestor::dod/@module,'000'),'.js')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <echo message="build.xml {$file} search: Concatenating search.js to {$search-filename}"/>
                <concat destfile="{concat($stagedir,'/Install_Online_Help_on_NX/',$lang,'/',$search-filename)}" append="yes">
                  <filelist dir="{$build-stagedir-d}" files="search.js"/>
                </concat>
              </xsl:if>
            </target>
            <!--target name="test.if.only.one.topic">
              <resourcecount property="only.one.topic" when="equal" count="1">
                <fileset dir="{$build-stagedir-d}">
                  <include name="????????????????.html"/>
                </fileset>
              </resourcecount>
            </target>
            <target name="eliminate.index" if="only.one.topic" depends="test.if.only.one.topic">
              <echo message="Only one topic, so index.html will be overwritten with this topic file"/>
              <copy todir="{$build-stagedir-d}" overwrite="true">
                <fileset dir="{$build-stagedir-d}">
                  <include name="????????????????.html"/>
                </fileset>
                <mergemapper to="index.html"/>
              </copy>
            </target-->  
            <target name="clean">
              <echo message="build.xml {$file} clean: Cleaning dirs"/>
              <delete includeemptydirs="true" quiet="false" failonerror="false">
                <fileset dir="{$build-tempdir-d}"/>
                <fileset dir="{$build-stagedir-d}"/>
              </delete>
            </target>
          </project>
          <!-- END of the ANT file -->
        </xsl:result-document>
        <!-- BEGIN of the PROJECT.XML deliverable -->
        <xsl:message>antfiles.xslt: Writing html deliverable <xsl:value-of select="$unique-id"/> to project.xml</xsl:message>
        <deliverable id="_{$unique-id}" xmlns="https://www.dita-ot.org/project"><!-- underscore, because id must not start with number -->
          <context xmlns="https://www.dita-ot.org/project">
            <input href="file:/{$exportdir}/{$ditamapbasename}" xmlns="https://www.dita-ot.org/project"/>
          </context>
          <output href="file:/{$build-stagedir-d}" xmlns="https://www.dita-ot.org/project"/>
          <publication transtype="html5" xmlns="https://www.dita-ot.org/project">
            <param name="clean.temp" value="no" xmlns="https://www.dita-ot.org/project"/><!-- for DEBUGGING -->
            <param name="dita.temp.dir" value="{$build-tempdir-d}" xmlns="https://www.dita-ot.org/project"/>
            <param name="buildParameterLanguage" value="{$lang}" xmlns="https://www.dita-ot.org/project"/>
            <param name="buildParameterDate" value="{$build-date}" xmlns="https://www.dita-ot.org/project"/>
            <param name="buildParameterDitamap" value="file:/{$exportdir}/{$ditamapbasename}" xmlns="https://www.dita-ot.org/project"/>
            <param name="buildParameterBuildTempDirD" value="{$build-tempdir-d}" xmlns="https://www.dita-ot.org/project"/><!-- for writing metadata.xml -->
            <param name="nav-toc" value="partial" xmlns="https://www.dita-ot.org/project"/><!-- confirming default none -->
            <param name="args.cssroot" value="{$plugindir}/css" xmlns="https://www.dita-ot.org/project"/>
            <param name="args.css" value="html5.css" xmlns="https://www.dita-ot.org/project"/>
            <param name="args.copycss" value="yes" xmlns="https://www.dita-ot.org/project"/>
            <param name="html5.toc.generate" value="yes" xmlns="https://www.dita-ot.org/project"/><!-- confirming default yes -->  
          </publication>
        </deliverable>
        <!-- END of the PROJECT.XML deliverable -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  

  <!-- templates for creating the navigation that's part of the build output (= on the CD) -->
  
  <xsl:template match="dod" mode="navigate">
    <xsl:if test="string-length(@module)>0 or @documentId='XDOC'">
      <xsl:message>antfiles.xslt: writing version file:///<xsl:value-of select="$stagedir"/>/Install_Online_Help_on_NX/version.ini</xsl:message>
      <xsl:result-document href="file:///{$stagedir}/Install_Online_Help_on_NX/version.ini" format="text">
        <xsl:if test="@documentId='XDOC'">
          <xsl:text>[NXOnlineHelp]&#10;</xsl:text>
        </xsl:if>
        <xsl:if test="string-length(@module)>0">
          <xsl:text>[OnlineHelp]&#10;</xsl:text>
          <!--xsl:value-of select="concat('MODULE=',@title,'&#10;')"/-->
          <xsl:value-of select="'SIZE=#average-language-folder-size-in-kilobytes#&#10;'"/>
        </xsl:if>
        <xsl:value-of select="concat('VERSION=',@documentId,' CD ',@version)"/>
      </xsl:result-document>
    </xsl:if>

    <!-- navigation file on the CD for selecting the language --> 

    <xsl:message>antfiles.xslt: writing buildnavigation to file:///<xsl:value-of select="$stagedir"/>/User_Documentation/index.html</xsl:message>
    <xsl:result-document href="file:///{$stagedir}/User_Documentation/index.html" format="xml">
      <html>
        <head>
          <xsl:comment>Build date: <xsl:value-of select="$build-date"/></xsl:comment>
          <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
          <title><xsl:value-of select="@title"/> User Documentation</title>
          <link rel="StyleSheet" href="style.css" type="text/css"/>
        </head>
        <body>
          <div class="body centering">
            <img src="img/site-borders.gif"/>
            <!-- TITLE -->
            <table class="title spacebefore">
              <tr>
                <td class="title">
                  <xsl:if test="not(@whitelabel = 'true')">
                    <img height="50pt" src="img/agfalogo.png"/>
                  </xsl:if>
                </td>
                <td class="title">
                  <span class="title"><xsl:value-of select="@title"/></span><br/>
                  <span class="subtitle">User Documentation</span>
                </td>
                <td class="title">
                </td>
              </tr>
            </table>
            <!-- LANGUAGES -->
            <div class="gridcontainer centered centering">
              <xsl:for-each select="languages/language">
                <xsl:variable name="languagecodes">
                  <xsl:call-template name="languagecodes">
                    <xsl:with-param name="code" select="@code"/>
                  </xsl:call-template>
                </xsl:variable>
                <a href="{$languagecodes/filename}/index.html">
                  <span class="manual grid gridsmall">
                    <xsl:value-of select="$languagecodes/name"/>
                  </span>
                </a>
              </xsl:for-each>
            </div>
            <!-- INSTALLERS -->
            <div class="gridcontainer centered centering">
              <xsl:if test="@documentId='XDOC'">
                <a href="../Install_Online_Help_on_NX/">
                  <span class="manual grid gridsmall">Install Online Help on the NX Workstation</span>
                </a>
                <a href="Service%20Software/NX%20Application%20NX%20X.0.22.00/AdditionalInstallers/OfficeViewer/">
                  <span class="manual grid gridsmall">Install NX Office Viewer</span>
                </a>
              </xsl:if>
              <xsl:if test="string-length(@module)>0">
                <a href="../Install_Online_Help_on_NX/">
                  <span class="manual grid gridsmall">Install Online Help on the NX Workstation</span>
                </a>
              </xsl:if>
            </div>
            <p class="version spacebefore centered">
              <a href="../adobe-reader" title="Install Acrobat Reader">
                <xsl:text>Install Acrobat Reader</xsl:text>
              </a>
            </p>
            <p class="version spacebefore centered">
              <xsl:text>Version </xsl:text>
              <xsl:value-of select="@documentId"/>
              <xsl:text> CD </xsl:text>
              <xsl:value-of select="@version"/>
            </p>
            <img src="img/site-borders.gif" class="spacebefore"/>
          </div>
        </body>
      </html>
    </xsl:result-document>

    <!-- END OF navigation file on the CD for selecting the language --> 

    <!-- copy static files to the "User_Documentation" root folder -->

    <xsl:result-document href="file:///{$stagedir}/User_Documentation/style.css" method="text">
      <xsl:value-of select="unparsed-text(concat('file:///',replace($templatedir,'\\','/'),'/build-dod/static/style.css'))"/>
    </xsl:result-document>

    <!-- END copying static files to the "User_Documentation" root folder -->

    <!-- render navigation page for each language -->
    <xsl:apply-templates mode="navigate"/>
  </xsl:template>

  <xsl:template match="languages/language" mode="navigate">
    <xsl:variable name="languagecodes">
      <xsl:call-template name="languagecodes">
        <xsl:with-param name="code" select="@code"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lang" select="$languagecodes/filename"/>
    <xsl:if test="string-length(ancestor::dod/@module)>0">
      <xsl:variable name="module-filename">module<xsl:value-of select="format-number(ancestor::dod/@module,'000')"/>.js</xsl:variable>
      <xsl:message>antfiles.xslt: writing module javascript file:///<xsl:value-of select="$stagedir"/>/Install_Online_Help_on_NX/<xsl:value-of select="$lang"/>/<xsl:value-of select="$module-filename"/></xsl:message>

      <!-- module javascript file in the "Install_Online_Help_on_NX" containing the link that can be loaded by the navigation file of the NX Online Help -->

      <xsl:result-document href="file:///{$stagedir}/Install_Online_Help_on_NX/{$lang}/{$module-filename}" format="text">
        <xsl:for-each select="documents/document[@level = 'system' or @level = 'component'][(formats/format/@name = 'xhtml' and not(@installable = 'no')) or @installable = 'yes']">
          <xsl:variable name="html-link">
            <div class="grid gridbig">
              <xsl:apply-templates select="." mode="navigate-cell">
                <xsl:with-param name="navigation" select="'HELP'" tunnel="yes"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="." mode="navigate-illustration">
                <xsl:with-param name="module" select="'true'" tunnel="yes"/>
              </xsl:apply-templates>
            </div>
          </xsl:variable>
          <xsl:variable name="html-link-string">
            <xsl:apply-templates select="$html-link" mode="nodetostring"/>
          </xsl:variable>
document.getElementById('modules').insertAdjacentHTML('beforeend',"<xsl:value-of select="replace($html-link-string,'&quot;','\\&quot;')"/>");
        </xsl:for-each>
        <xsl:for-each select="documents/document[@level = 'side'][(formats/format/@name = 'xhtml' and not(@installable = 'no')) or @installable = 'yes']">
          <xsl:variable name="html-link"><!-- fallback for old NX platforms that only have id="modules" hook -->
            <div class="grid gridbig">
              <xsl:apply-templates select="." mode="navigate-cell">
                <xsl:with-param name="navigation" select="'HELP'" tunnel="yes"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="." mode="navigate-illustration">
                <xsl:with-param name="module" select="'true'" tunnel="yes"/>
              </xsl:apply-templates>
            </div>
          </xsl:variable>
          <xsl:variable name="html-link-string">
            <xsl:apply-templates select="$html-link" mode="nodetostring"/>
          </xsl:variable>
          <xsl:variable name="html-link-side">
            <xsl:apply-templates select="." mode="navigate-cell">
              <xsl:with-param name="navigation" select="'HELP'" tunnel="yes"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:variable name="html-link-side-string">
            <xsl:apply-templates select="$html-link-side" mode="nodetostring"/>
          </xsl:variable>
typeof sideModules != 'undefined' ? document.getElementById('sideModules').insertAdjacentHTML('beforeend',"<xsl:value-of select="replace($html-link-side-string,'&quot;','\\&quot;')"/>\n") : document.getElementById('modules').insertAdjacentHTML('beforeend',"<xsl:value-of select="replace($html-link-side-string,'&quot;','\\&quot;')"/>\n");
        </xsl:for-each>
      </xsl:result-document>

      <!-- END OF module javascript file containing the link that can be loaded by the navigation file of the NX Online Help -->

    </xsl:if>
    <xsl:message>antfiles.xslt: writing translated CD navigation to file:///<xsl:value-of select="$stagedir"/>/<xsl:value-of select="$lang"/>/index.html</xsl:message>

    <!-- navigation file on the CD to choose between the available manuals -->

    <xsl:result-document href="file:///{$stagedir}/User_Documentation/{$lang}/index.html" format="html">
      <html>
        <head>
          <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
          <title><xsl:value-of select="ancestor::dod/@title"/></title>
          <link rel="StyleSheet" href="style.css" type="text/css"/>
          <script type="text/javascript" src="jquery.min.js"></script>
          <script type="text/javascript" src="scaletofit.js"></script>
        </head>
        <xsl:variable name="language" select="."/>
        <xsl:variable name="documents" select="ancestor::dod//document"/>
        <body>
          <div class="body">
            <img src="img/site-borders.gif"/>
            <!-- TITLE -->
            <table class="title spacebefore">
              <tr>
                <td class="title">
                  <a href="../index.html">
                    <img src="img/back.png"/>
                  </a>
                </td>
                <td class="title">
                  <span class="title"><xsl:value-of select="ancestor::dod/@title"/></span>
                </td>
                <td class="title right">
                  <xsl:if test="not(ancestor::dod/@whitelabel = 'true')">
                    <img height="50pt" src="img/agfalogo.png"/>
                  </xsl:if>
                </td>
              </tr>
            </table>
            <xsl:comment>SYSTEM LEVEL DOCUMENTATION</xsl:comment>
            <table class="system spacebefore">
              <tr>
                <td class="left side"/>
                <td class="system">
                  <div class="centering centered">
                    <div class="grid gridbig">
                      <xsl:for-each select="documents/document[@level = 'system']">
                        <xsl:apply-templates select="." mode="navigate-cell">
                          <xsl:with-param name="navigation" tunnel="yes">CD</xsl:with-param>
                        </xsl:apply-templates>
                      </xsl:for-each>
                      <xsl:apply-templates select="documents/document[@level = 'system'][1]" mode="navigate-illustration"/>
                    </div>
                  </div>
                </td>
                <td class="right side"></td>
              </tr>
            </table>
            <xsl:comment>COMPONENT LEVEL DOCUMENTATION</xsl:comment>
            <div class="spacebefore">
              <div class="gridcontainer centering centered">
                <xsl:for-each select="documents/document[@level = 'component']">
                  <div class="grid gridbig">
                    <xsl:apply-templates select="." mode="navigate-cell">
                      <xsl:with-param name="navigation" tunnel="yes">CD</xsl:with-param>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="." mode="navigate-illustration"/>
                  </div>
                </xsl:for-each>
              </div>
            </div>
            <xsl:comment>EXTRA DOCUMENTATION</xsl:comment>
            <div class="spacebefore">
              <div class="gridcontainer centering centered">
                  <div class="grid">
                    &#xA0;<!-- table should not be empty -->
                    <xsl:apply-templates select="documents/document[@level='side']" mode="navigate-cell">
                      <xsl:with-param name="navigation" tunnel="yes">CD</xsl:with-param>
                    </xsl:apply-templates>
                  </div>
              </div>
            </div>
            <img src="img/site-borders.gif" class="spacebefore"/>
          </div>
        </body>
      </html>
    </xsl:result-document>

    <!-- END OF navigation file on the CD to choose between the available manuals -->

    <!-- copy static files to the "User_Documentation" language folder -->

    <xsl:result-document href="file:///{$stagedir}/User_Documentation/{$lang}/style.css" method="text">
      <xsl:value-of select="unparsed-text(concat('file:///',replace($templatedir,'\\','/'),'/build-dod/static/style.css'))"/>
    </xsl:result-document>
    <xsl:result-document href="file:///{$stagedir}/User_Documentation/{$lang}/jquery.min.js" method="text">
      <xsl:value-of select="unparsed-text(concat('file:///',replace($templatedir,'\\','/'),'/build-dod/static/jquery.min.js'))"/>
    </xsl:result-document>
    <xsl:result-document href="file:///{$stagedir}/User_Documentation/{$lang}/scaletofit.js" method="text">
      <xsl:value-of select="unparsed-text(concat('file:///',replace($templatedir,'\\','/'),'/build-dod/static/scaletofit.js'))"/>
    </xsl:result-document>

    <!-- END copying static files to the "User_Documentation" language folder -->

    <!-- navigation file in the ONLINE HELP (only XDOC!!) to choose between the available manuals (including modules) -->

    <xsl:if test="ancestor::dod/@documentId = 'XDOC'">
      <xsl:message>antfiles.xslt: writing local Online Help-ONLY build navigation to file:///<xsl:value-of select="$stagedir"/>/Install_Online_Help_on_NX/<xsl:value-of select="$lang"/>/index.html</xsl:message>

      <xsl:result-document href="file:///{$stagedir}/Install_Online_Help_on_NX/{$lang}/index.html" format="html">
        <html>
          <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <title><xsl:value-of select="ancestor::dod/@title"/></title>
            <link rel="StyleSheet" href="style.css" type="text/css"/>
            <script type="text/javascript" src="jquery.min.js"></script>
            <script type="text/javascript" src="scaletofit.js"></script>
          </head>
          <xsl:variable name="language" select="."/>
          <xsl:variable name="documents" select="ancestor::dod//document"/>
          <body>
            <div class="body">
              <img src="img/site-borders.gif"/>
              <!-- TITLE -->
              <table class="title spacebefore">
                <tr>
                  <td class="title">
                  </td>
                  <td class="title">
                    <span class="title"><xsl:value-of select="ancestor::dod/@title"/></span>
                  </td>
                  <td class="title right">
                    <xsl:if test="not(ancestor::dod/@whitelabel = 'true')">
                      <img height="50pt" src="img/agfalogo.png"/>
                    </xsl:if>
                  </td>
                </tr>
              </table>
              <xsl:comment>SYSTEM LEVEL DOCUMENTATION</xsl:comment>
              <table class="system spacebefore">
                <tr>
                  <td class="left side"/>
                  <td class="system">
                    <div class="centering centered">
                      <div class="grid gridbig">
                        <xsl:for-each select="documents/document[@level = 'system'][(formats/format/@name = 'xhtml' and not(@installable = 'no')) or @installable = 'yes']">
                          <xsl:apply-templates select="." mode="navigate-cell">
                            <xsl:with-param name="navigation" select="'HELP'" tunnel="yes"/>
                          </xsl:apply-templates>
                        </xsl:for-each>
                        <xsl:apply-templates select="documents/document[@level = 'system'][1]" mode="navigate-illustration"/>
                      </div>
                    </div>
                  </td>
                  <td class="right side">
                    <div class="grid gridbig">
                      <div class="manual"><a href="search.html">Search</a></div>
                    </div>
                  </td>
                </tr>
              </table>
              <xsl:comment>COMPONENT LEVEL DOCUMENTATION</xsl:comment>
              <div class="spacebefore">
                <div class="gridcontainer centering centered" id="modules">
                  <xsl:for-each select="documents/document[@level = 'component'][(formats/format/@name = 'xhtml' and not(@installable = 'no')) or @installable = 'yes']">
                    <div class="grid gridbig">
                      <xsl:apply-templates select="." mode="navigate-cell">
                        <xsl:with-param name="navigation" select="'HELP'" tunnel="yes"/>
                      </xsl:apply-templates>
                      <xsl:apply-templates select="." mode="navigate-illustration"/>
                    </div>
                  </xsl:for-each>
                </div>
              </div>
              <xsl:comment>EXTRA DOCUMENTATION</xsl:comment>
              <div class="spacebefore">
                <div class="gridcontainer centering centered">
                  <div class="grid" id="sideModules">
                    &#xA0;<!-- table should not be empty -->
                    <xsl:for-each select="documents/document[@level = 'side'][(formats/format/@name = 'xhtml' and not(@installable = 'no')) or @installable = 'yes']">
                      <xsl:apply-templates select="." mode="navigate-cell">
                        <xsl:with-param name="navigation" select="'HELP'" tunnel="yes"/>
                      </xsl:apply-templates>
                    </xsl:for-each>
                  </div>
                </div>
              </div>
              <img src="img/site-borders.gif" class="spacebefore"/>
            </div>
            <script type="text/javascript" src="../../modules/{$lang}/module001.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module003.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module004.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module005.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module006.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module007.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module008.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module009.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module010.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module011.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module012.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module013.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module014.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module015.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module016.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module017.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module018.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module019.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/module020.js"></script>
          </body>
        </html>
      </xsl:result-document>

      <!-- END OF navigation file in the ONLINE HELP (only XDOC!!) to choose between the available manuals (including modules) -->

      <!-- search file in the ONLINE HELP (only XDOC!!) to search the available manuals (including modules) -->

      <xsl:message>antfiles.xslt: writing local Online Help-ONLY build navigation to file:///<xsl:value-of select="$stagedir"/>/Install_Online_Help_on_NX/<xsl:value-of select="$lang"/>/search.html</xsl:message>

      <xsl:result-document href="file:///{$stagedir}/Install_Online_Help_on_NX/{$lang}/search.html" format="html">
        <html>
          <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <title><xsl:value-of select="ancestor::dod/@title"/></title>
            <link rel="StyleSheet" href="style.css" type="text/css"/>
            <script type="text/javascript" src="jquery.min.js"></script>
            <script type="text/javascript" src="scaletofit.js"></script>
            <script src="lunr.js"></script>
            <script src="lunr.stemmer.support.js"></script>
            <script src="lunr.{$lang}.js"></script>
            <script src="lunrclient.js"></script>
          </head>
          <xsl:variable name="language" select="."/>
          <xsl:variable name="documents" select="ancestor::dod//document"/>
          <body>
            <div class="body">
              <img src="img/site-borders.gif"/>
              <!-- TITLE -->
              <table class="title spacebefore">
                <tr>
                  <td class="title">
                  </td>
                  <td class="title">
                    <span class="title"><xsl:value-of select="ancestor::dod/@title"/></span>
                  </td>
                  <td class="title right">
                    <xsl:if test="not(ancestor::dod/@whitelabel = 'true')">
                      <img height="50pt" src="img/agfalogo.png"/>
                    </xsl:if>
                  </td>
                </tr>
              </table>
              <div class="spacebefore">
                <div class="gridcontainer centering centered">
                  <!--- Search form -->
                  <form id="lunrSearchForm" name="lunrSearchForm" action="javascript:;"
                        onsubmit="return searchLunr(q.value)">
                    <input class="search-input" name="q" placeholder="{rds:localize('enter_search_term',$lang)}" type="text"/>
                    <input class="button nopadding" type="submit" value="{rds:localize('search_button',$lang)}"/>
                  </form>
                  <div id="searchResults"></div>
                  <div id="noSearchResults" style="display:none;">
                    <div class="grid gridwide">
                      <div class="manual">
                        <xsl:value-of select="rds:localize('no_search_results',$lang)"/>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <img src="img/site-borders.gif" class="spacebefore"/>
            </div>
            <script type="text/javascript" src="searchxdoc.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search001.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search003.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search004.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search005.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search006.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search007.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search008.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search009.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search010.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search011.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search012.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search013.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search014.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search015.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search016.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search017.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search018.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search019.js"></script>
            <script type="text/javascript" src="../../modules/{$lang}/search020.js"></script>
          </body>
        </html>
      </xsl:result-document>

      <!-- END OF search file in the ONLINE HELP (only XDOC!!) to search the available manuals (including modules) -->

      <!-- copy static files to the "Install_Online_Help_on_NX" language folder (only XDOC!!) -->

      <xsl:result-document href="file:///{$stagedir}/Install_Online_Help_on_NX/{$lang}/style.css" method="text">
        <xsl:value-of select="unparsed-text(concat('file:///',replace($templatedir,'\\','/'),'/build-dod/static/style.css'))"/>
      </xsl:result-document>
      <xsl:result-document href="file:///{$stagedir}/Install_Online_Help_on_NX/{$lang}/jquery.min.js" method="text">
        <xsl:value-of select="unparsed-text(concat('file:///',replace($templatedir,'\\','/'),'/build-dod/static/jquery.min.js'))"/>
      </xsl:result-document>
      <xsl:result-document href="file:///{$stagedir}/Install_Online_Help_on_NX/{$lang}/scaletofit.js" method="text">
        <xsl:value-of select="unparsed-text(concat('file:///',replace($templatedir,'\\','/'),'/build-dod/static/scaletofit.js'))"/>
      </xsl:result-document>
      <xsl:result-document href="file:///{$stagedir}/Install_Online_Help_on_NX/{$lang}/lunr.js" method="text">
        <xsl:value-of select="unparsed-text(concat('file:///',replace($templatedir,'\\','/'),'/build-dod/static/lunr.js'))"/>
      </xsl:result-document>
      <xsl:result-document href="file:///{$stagedir}/Install_Online_Help_on_NX/{$lang}/lunr.stemmer.support.js" method="text">
        <xsl:value-of select="unparsed-text(concat('file:///',replace($templatedir,'\\','/'),'/build-dod/lunrjs/node_modules/lunr-languages/lunr.stemmer.support.js'))"/>
      </xsl:result-document>
      <xsl:variable name="lunr-language-file" select="concat('file:///',replace($templatedir,'\\','/'),'/build-dod/lunrjs/node_modules/lunr-languages/lunr.',$lang,'.js')"/>
      <xsl:if test="unparsed-text-available($lunr-language-file)">
        <xsl:result-document href="file:///{$stagedir}/Install_Online_Help_on_NX/{$lang}/lunr.{$lang}.js" method="text">
          <xsl:value-of select="unparsed-text($lunr-language-file)"/>
        </xsl:result-document>
      </xsl:if>
      <xsl:result-document href="file:///{$stagedir}/Install_Online_Help_on_NX/{$lang}/lunrclient.js" method="text">
        <xsl:value-of select="unparsed-text(concat('file:///',replace($templatedir,'\\','/'),'/build-dod/static/lunrclient.js'))"/>
      </xsl:result-document>

      <!-- END copying static files to the "Install_Online_Help_on_NX" language folder (only XDOC!!) -->

    </xsl:if>
  </xsl:template>

  <xsl:template match="document" mode="navigate-cell">
    <!-- return hypertext link to navigate to some manual 
         (this template is used for CD and HELP navigation) -->
    <xsl:param name="navigation" select="'CD'" tunnel="yes"/>
    <div class="manual">
      <xsl:variable name="title">
        <xsl:call-template name="title"/>
      </xsl:variable>
      <xsl:variable name="subtitle">
        <xsl:call-template name="subtitle"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$navigation = 'CD'">
          <xsl:choose>
            <xsl:when test="descendant::format[@name='pdf']">
              <!-- Title and subtitle with link to the PDF file -->
              <a>
                <xsl:attribute name="href">
                  <xsl:apply-templates select="descendant::format[@name='pdf']" mode="navigate"/>
                </xsl:attribute>
                <span class="line">
                  <xsl:value-of select="$title"/>
                </span>
                <xsl:if test="normalize-space($subtitle) != ''">
                  <span class="line submanual">
                    <xsl:value-of select="$subtitle"/>
                  </span>
                </xsl:if>
              </a>
              <xsl:if test="descendant::format[@name='xhtml']">
                <!-- fixed string "browse online help" with link to Online help -->
                <a>
                  <xsl:attribute name="href">
                    <xsl:apply-templates select="descendant::format[@name='xhtml']" mode="navigate"/>
                  </xsl:attribute>
                  <span class="line submanual">
                    <xsl:call-template name="localize">
                      <xsl:with-param name="string" select="'browse_online_help'"/>
                      <xsl:with-param name="lang" select="ancestor::language/@code"/>
                    </xsl:call-template>
                  </span>
                </a>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <!-- Title and subtitle with link to the Online help --> 
              <a>
                <xsl:attribute name="href">
                  <xsl:apply-templates select="descendant::format[@name='xhtml']" mode="navigate"/>
                </xsl:attribute>
                <span class="line">
                  <xsl:value-of select="$title"/>
                </span>
                <xsl:if test="normalize-space($subtitle) != ''">
                  <span class="line submanual">
                    <xsl:value-of select="$subtitle"/>
                  </span>
                </xsl:if>
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise><!-- $navigation = 'HELP' -->
          <xsl:choose>
            <xsl:when test="descendant::format[@name='xhtml']">
              <!-- Title and subtitle with link to the Online Help file -->
              <a>
                <xsl:attribute name="href">
                  <xsl:apply-templates select="descendant::format[@name='xhtml']" mode="navigate"/>
                </xsl:attribute>
                <span class="line">
                  <xsl:value-of select="$title"/>
                </span>
                <xsl:if test="normalize-space($subtitle) != ''">
                  <span class="line submanual">
                    <xsl:value-of select="$subtitle"/>
                  </span>
                </xsl:if>
              </a>
              <xsl:if test="descendant::format[@name='pdf'] and @installable='yes'">
                <!-- fixed string "PDF" with link to Online help -->
                <a>
                  <xsl:attribute name="href">
                    <xsl:apply-templates select="descendant::format[@name='pdf']" mode="navigate"/>
                  </xsl:attribute>
                  <span class="line submanual">[PDF]</span>
                </a>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <!-- Title and subtitle with link to the PDF --> 
              <a>
                <xsl:attribute name="href">
                  <xsl:apply-templates select="descendant::format[@name='pdf']" mode="navigate"/>
                </xsl:attribute>
                <span class="line">
                  <xsl:value-of select="$title"/>
                </span>
                <xsl:if test="normalize-space($subtitle) != ''">
                  <span class="line submanual">
                    <xsl:value-of select="$subtitle"/>
                  </span>
                </xsl:if>
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@language = 'untranslated'">
        <span class="line submanual">
          <xsl:call-template name="localize">
            <xsl:with-param name="string" select="'english_only'"/>
            <xsl:with-param name="lang" select="ancestor::language/@code"/>
          </xsl:call-template>
        </span>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="document" mode="navigate-illustration">
    <xsl:param name="module" select="'false'" tunnel="yes"/>
    <xsl:variable name="dod-title-slug">
      <xsl:call-template name="string-to-slug">
        <xsl:with-param name="text" select="ancestor::dod/@title"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="languagecodes">
      <xsl:call-template name="languagecodes">
        <xsl:with-param name="code">
          <xsl:value-of select="ancestor::language/@code"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="solution-and-language-folder">
      <xsl:choose>
        <xsl:when test="$module='true'"><!-- rendering html plugged in by javascript -->
          <xsl:choose>
            <xsl:when test="@language='untranslated'">
              <xsl:value-of select="concat('../../modules/EN/',$dod-title-slug,'/')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('../../modules/',$languagecodes/filename,'/',$dod-title-slug,'/')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="@language='untranslated'">../EN/</xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="pictureframe">
      <div class="picturebox">
          <xsl:if test="@illustration != ''">
            <img class="pictureportrait" src="{$solution-and-language-folder}illustrations/{@illustration}"></img>
          </xsl:if>
      </div>
    </div>                      
  </xsl:template>

  <xsl:template match="format[@name='pdf']" mode="navigate">
    <!-- returns the URL 
         (PDF links are only rendered on CD navigation) -->
    <xsl:param name="navigation" select="'CD'" tunnel="yes"/>
    <xsl:variable name="d" select="ancestor::document"/>
    <xsl:variable name="dod-id" select="ancestor::dod/@documentId"/>
    <xsl:variable name="doc-id" select="$d/@documentId"/>
    <xsl:variable name="installable" select="$d/@installable"/>
    <xsl:variable name="dod-title-slug">
      <xsl:call-template name="string-to-slug">
        <xsl:with-param name="text" select="ancestor::dod/@title"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:call-template name="filename">
        <xsl:with-param name="string">
          <xsl:call-template name="englishtitle">
            <xsl:with-param name="document" select="$d"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="title-as-filename">
      <xsl:call-template name="filename">
        <xsl:with-param name="string" select="$title"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="fileType">
      <xsl:choose>
        <xsl:when test="$d/@fileType != ''">
          <xsl:value-of select="$d/@fileType"/>
        </xsl:when>
        <xsl:otherwise>pdf</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="languagecodes">
      <xsl:call-template name="languagecodes">
        <xsl:with-param name="code">
          <xsl:value-of select="ancestor::language/@code"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lang">
      <xsl:choose>
        <xsl:when test="$d/@language='untranslated'">EN</xsl:when>
        <xsl:otherwise><xsl:value-of select="$languagecodes/filename"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- there are four types of files that contain links to pdf manuals:

         1/ [NX CD]/User_Documentation/LL/index.html (browsing the CD)

              <=> "$dod-id = 'XDOC'"  &  "$navigation='CD'" 

            installable='yes':

              ../../Install_Online_Help_on_NX/LL/pdf/xxxx.pdf

            installable='no' (default): 

              ../LL/pdf/xxxx.pdf

         2/ [NX CD]/Install_Online_Help_on_NX/LL/index.html (installed on NX as 
              Documentation/NX/LL/index.html)

              <=> "$dod-id = 'XDOC'"  &  "$navigation='HELP'"

              ../LL/pdf/xxxx.pdf
        
         3/ [module CD]/User_Documentation/LL/index.html (browsing the CD)

              <=> "$dod-id <> 'XDOC'"  &  "$navigation='CD'"

            installable='yes': 

              ../../Install_Online_Help_on_NX/LL/solution/pdf/xxxx.pdf

            installable='no' (default):

              ../LL/pdf/xxxx.pdf

         4/ [module CD]/Install_Online_Help_on_NX/LL/module001.js (installed on NX and merged with the 2/ 
              Documentation/NX/LL/index.html)

              <=> "$dod-id <> 'XDOC'"  &  "$navigation='HELP'"

              ../../modules/LL/solution/pdf/xxxx.pdf
              
        Note: if property @fileType is present, '.pdf' is replaced by '.<@fileType>'
      -->
    <xsl:choose>
      <xsl:when test="$dod-id = 'XDOC'">
        <xsl:choose>
          <xsl:when test="$navigation='CD'">
            <xsl:choose>
              <xsl:when test="$installable='yes'">
                <xsl:value-of select="concat('../../Install_Online_Help_on_NX/',$lang,'/pdf/',$doc-id,'-',$lang,'-',normalize-space($title-as-filename),'.',$fileType)"/>
              </xsl:when>
              <xsl:otherwise><!-- $installable='yes' or undefined -->
                <xsl:value-of select="concat('../',$lang,'/pdf/',$doc-id,'-',$lang,'-',normalize-space($title-as-filename),'.',$fileType)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise><!-- $navigation='HELP' -->
            <xsl:value-of select="concat('../',$lang,'/pdf/',$doc-id,'-',$lang,'-',normalize-space($title-as-filename),'.',$fileType)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise><!-- $dod-id = some four-digit document number -->
        <xsl:choose>
          <xsl:when test="$navigation='CD'">
            <xsl:choose>
              <xsl:when test="$installable='yes'">
                <xsl:value-of select="concat('../../Install_Online_Help_on_NX/',$lang,'/',$dod-title-slug,'/pdf/',$doc-id,'-',$lang,'-',normalize-space($title-as-filename),'.',$fileType)"/>
              </xsl:when>
              <xsl:otherwise><!-- $installable='yes' or undefined -->
                <xsl:value-of select="concat('../',$lang,'/pdf/',$doc-id,'-',$lang,'-',normalize-space($title-as-filename),'.',$fileType)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise><!-- $navigation='HELP' -->
            <xsl:value-of select="concat('../../modules/',$lang,'/',$dod-title-slug,'/pdf/',$doc-id,'-',$lang,'-',normalize-space($title-as-filename),'.',$fileType)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="format[@name='xhtml']" mode="navigate">
    <!-- returns the URL 
         (HTML links can appear on CD or on HELP navigation) -->
    <xsl:param name="navigation" select="'CD'" tunnel="yes"/>
    <xsl:variable name="d" select="ancestor::document"/>
    <xsl:variable name="dod-id" select="ancestor::dod/@documentId"/>
    <xsl:variable name="doc-id" select="$d/@documentId"/>
    <xsl:variable name="installable" select="$d/@installable"/>
    <xsl:variable name="dod-title-slug">
      <xsl:call-template name="string-to-slug">
        <xsl:with-param name="text" select="ancestor::dod/@title"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="languagecodes">
      <xsl:call-template name="languagecodes">
        <xsl:with-param name="code">
          <xsl:value-of select="ancestor::language/@code"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lang">
      <xsl:choose>
        <xsl:when test="$d/@language='untranslated'">EN</xsl:when>
        <xsl:otherwise><xsl:value-of select="$languagecodes/filename"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- there are four types of files that contain links to html manuals:

         1/ [NX CD]/User_Documentation/LL/index.html (browsing the CD)

              <=> "$dod-id = 'XDOC'"  &  "$navigation='CD'" 

            installable='no': 

              ../LL/html/9999-LL/index.html

            installable='yes' (default):

              ../../Install_Online_Help_on_NX/LL/html/9999-LL/index.html

         2/ [NX CD]/Install_Online_Help_on_NX/LL/index.html (installed on NX as 
              Documentation/NX/LL/index.html)

              <=> "$dod-id = 'XDOC'"  &  "$navigation='HELP'"

              ../LL/html/9999-LL/index.html
        
         3/ [module CD]/User_Documentation/LL/index.html (browsing the CD)

              <=> "$dod-id <> 'XDOC'"  &  "$navigation='CD'"

            installable='no': 

              ../LL/html/9999-LL/index.html

            installable='yes' (default):

              ../../Install_Online_Help_on_NX/LL/solution/html/9999-LL/index.html

         4/ [module CD]/Install_Online_Help_on_NX/LL/module001.js (installed on NX and merged with the 2/ 
              Documentation/NX/LL/index.html)

              <=> "$dod-id <> 'XDOC'"  &  "$navigation='HELP'"

              ../../modules/LL/solution/html/9999-LL/index.html
              
      -->
    <xsl:choose>
      <xsl:when test="$dod-id = 'XDOC'">
        <xsl:choose>
          <xsl:when test="$navigation='CD'">
            <xsl:choose>
              <xsl:when test="$installable='no'">
                <xsl:value-of select="concat('../',$lang,'/html/',$doc-id,'-',$lang,'/index.html')"/>
              </xsl:when>
              <xsl:otherwise><!-- $installable='yes' or undefined -->
                <xsl:value-of select="concat('../../Install_Online_Help_on_NX/',$lang,'/html/',$doc-id,'-',$lang,'/index.html')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise><!-- $navigation='HELP' -->
            <xsl:value-of select="concat('../',$lang,'/html/',$doc-id,'-',$lang,'/index.html')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise><!-- $dod-id = some four-digit document number -->
        <xsl:choose>
          <xsl:when test="$navigation='CD'">
            <xsl:choose>
              <xsl:when test="$installable='no'">
                <xsl:value-of select="concat('../',$lang,'/html/',$doc-id,'-',$lang,'/index.html')"/>
              </xsl:when>
              <xsl:otherwise><!-- $installable='yes' or undefined -->
                <xsl:value-of select="concat('../../Install_Online_Help_on_NX/',$lang,'/',$dod-title-slug,'/html/',$doc-id,'-',$lang,'/index.html')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise><!-- $navigation='HELP' -->
            <xsl:value-of select="concat('../../modules/',$lang,'/',$dod-title-slug,'/html/',$doc-id,'-',$lang,'/index.html')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- UTILITY TEMPLATES -->
  
  <xsl:template name="languagecodes">
    <xsl:param name="code"/>
    <xsl:copy-of select="$languages/language[*=$code]/*"/>
  </xsl:template>

  <xsl:template name="englishtitle">
    <!-- if there's no English ditamap, take the localized title (that's why a language parameter is required)-->
    <xsl:param name="document" select="."/>
    <xsl:param name="lang_code" select="$document/ancestor::language/@code"/>
    <xsl:variable name="englishtitle">
      <xsl:call-template name="title">
        <xsl:with-param name="document" select="$document"/>
        <xsl:with-param name="lang_code" select="'en_US'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$englishtitle != $MISSINGTITLE">
        <xsl:value-of select="$englishtitle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="title">
          <xsl:with-param name="document" select="$document"/>
          <xsl:with-param name="lang_code" select="ancestor::language/@code"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>

  <xsl:template name="title">
    <xsl:param name="document" select="."/>
    <xsl:param name="lang_code" select="$document/ancestor::language/@code"/>
    <xsl:variable name="documentId" select="$document/@documentId"/>
    <xsl:variable name="document-in-right-lang" select="$document/ancestor::languages/language[@code = $lang_code]/documents/document[@documentId = $documentId]"/>
    <xsl:choose>
      <xsl:when test="$documentId != '' and $document-in-right-lang/@ditamap != ''">
        <xsl:variable name="url" select="concat('file:///',$exportdir,'/',$document-in-right-lang/@ditamap)"/>
        <xsl:variable name="ditamap" select="document($url)"/>
        <xsl:value-of select="$ditamap//mainbooktitle"/>
        <xsl:value-of select="$ditamap//map/title"/>
        <xsl:value-of select="$ditamap//map/@title"/>
        <xsl:message>antfiles.xslt title reading from <xsl:value-of select="$url"/></xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$MISSINGTITLE"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="subtitle">
    <xsl:param name="document" select="."/>
    <xsl:param name="lang_code">
      <xsl:choose>
        <xsl:when test="$document/@language = 'untranslated'">en_US</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$document/ancestor::language/@code"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:if test="normalize-space($document/@documenttype) != ''">
      <xsl:call-template name="localize">
        <xsl:with-param name="string" select="$document/@documenttype"/>
        <xsl:with-param name="lang" select="$lang_code"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="filename">
    <xsl:param name="string"/>
    <xsl:value-of select="replace(normalize-space($string),'[^a-zA-Z0-9_-]+','-')"/>
  </xsl:template>

  <xsl:template name="localize">
    <xsl:param name="string"/>
    <xsl:param name="lang"/>
    <xsl:if test="$string != ''">
      <xsl:variable name="languagecodes">
        <xsl:call-template name="languagecodes">
          <xsl:with-param name="code">
            <!--xsl:value-of select="ancestor::language/@code"/-->
            <xsl:value-of select="$lang"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="vars">file:/<xsl:value-of select="$plugindir"/>/xsl/strings-<xsl:value-of select="$languagecodes/xml"/>.xml</xsl:variable>
      <xsl:variable name="translation">
        <xsl:value-of select="document($vars)//str[contains(@name,$string)]"/>
      </xsl:variable>
      <xsl:value-of select="$translation"/>
      <xsl:if test="not($translation)">
        <xsl:message>antfiles.xslt template "localize" ERROR no translation found for "<xsl:value-of select="$string"/>" in "<xsl:value-of select="$vars"/>"</xsl:message>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:function name="rds:localize">
    <xsl:param name="string"/>
    <xsl:param name="lang"/>
    <xsl:call-template name="localize">
      <xsl:with-param name="string" select="$string"/>
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:function>

  <xsl:template name="string-to-lowercase">
    <xsl:param name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:param>
    <xsl:param name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
    <xsl:param name="text"/>
    <xsl:value-of select="translate($text,$ucletters,$lcletters)"/>
  </xsl:template>

  <xsl:template name="string-to-slug">
    <xsl:param name="text" select="''" />
    <xsl:variable name="dodgyChars" select="' ,.#_-!?*:;=+⁺'" />
    <xsl:variable name="replacementChar" select="'--------------'" />
    <xsl:variable name="lowercased"><xsl:call-template name="string-to-lowercase"><xsl:with-param name="text" select="normalize-space($text)" /></xsl:call-template></xsl:variable>
    <xsl:variable name="escaped"><xsl:value-of select="translate( $lowercased, $dodgyChars, $replacementChar )" /></xsl:variable>
    <xsl:variable name="ampRemoved"><xsl:value-of select="replace( $escaped, '&amp;', 'and' )" /></xsl:variable>
    <xsl:variable name="newlineRemoved"><xsl:value-of select="replace( $ampRemoved, '&#xA;', '-' )" /></xsl:variable>
    <xsl:variable name="cleaned"><xsl:value-of select="replace( $newlineRemoved, '--', '-' )" /></xsl:variable>
    <xsl:variable name="cleaned2"><xsl:value-of select="replace( $cleaned, '--', '-' )" /></xsl:variable>
    <xsl:value-of select="$cleaned2" />
  </xsl:template>

  <!-- nodetostring -->
  <xsl:variable name="q">
    <xsl:text>"</xsl:text>
  </xsl:variable>
  <xsl:variable name="empty"/>
  <xsl:template match="*" mode="selfclosetag">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:apply-templates select="@*" mode="attribs"/>
    <xsl:text>/&gt;</xsl:text>
  </xsl:template>
  <xsl:template match="*" mode="opentag">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:apply-templates select="@*" mode="attribs"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
  <xsl:template match="*" mode="closetag">
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
  <xsl:template match="* | text()" mode="nodetostring">
    <xsl:choose>
      <xsl:when test="boolean(name())">
        <xsl:choose>
          <!--
             if element is not empty
          -->
          <xsl:when test="normalize-space(.) != $empty or *">
            <xsl:apply-templates select="." mode="opentag"/>
              <xsl:apply-templates select="* | text()" mode="nodetostring"/>
            <xsl:apply-templates select="." mode="closetag"/>
          </xsl:when>
          <!--
             assuming emty tags are self closing, e.g. <img/>, <source/>, <input/>
          -->
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="selfclosetag"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="@*" mode="attribs">
    <xsl:if test="position() = 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="concat(name(), '=', $q, ., $q)"/>
    <xsl:if test="position() != last()">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- FOR DEBUGGING -->
  
  <xsl:template match="@*|*|text()" mode="identity">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()" mode="identity"/>
    </xsl:copy>
  </xsl:template>

  
</xsl:stylesheet>
