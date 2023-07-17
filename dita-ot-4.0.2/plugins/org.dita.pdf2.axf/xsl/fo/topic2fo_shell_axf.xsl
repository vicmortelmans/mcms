<?xml version="1.0" encoding="UTF-8"?><!--
This file is part of the DITA Open Toolkit project.

Copyright 2011 Jarno Elovirta

See the accompanying LICENSE file for applicable license.
--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  
  <xsl:import href="plugin:org.dita.pdf2:xsl/fo/topic2fo.xsl"/>

  <xsl:import href="plugin:org.dita.pdf2.axf:cfg/fo/attrs/tables-attr_axf.xsl"/>
  <xsl:import href="plugin:org.dita.pdf2.axf:cfg/fo/attrs/toc-attr_axf.xsl"/>
  <xsl:import href="plugin:org.dita.pdf2.axf:cfg/fo/attrs/index-attr_axf.xsl"/>
  <xsl:import href="plugin:org.dita.pdf2.axf:xsl/fo/root-processing_axf.xsl"/>
  <xsl:import href="plugin:org.dita.pdf2.axf:xsl/fo/index_axf.xsl"/>
  <xsl:import href="plugin:org.dita.pdf2.axf:xsl/fo/topic_axf.xsl"/>
  
  <xsl:import xmlns:dita="http://dita-ot.sourceforge.net" href="plugin:com.agfa.radsol.dod:cfg/fo/attrs/front-matter-attr.xsl"/><xsl:import href="plugin:com.agfa.radsol.dod:cfg/fo/attrs/commons-attr.xsl"/><xsl:import href="plugin:com.agfa.radsol.dod:cfg/fo/layout-masters.xsl"/><xsl:import href="plugin:com.agfa.radsol.dod:xsl/fo/front-matter.xsl"/><xsl:import href="plugin:com.agfa.radsol.dod:xsl/fo/root-processing.xsl"/><xsl:import href="plugin:com.agfa.radsol.dod:xsl/fo/static-content.xsl"/><xsl:import href="plugin:com.agfa.radsol.dod:xsl/fo/tables_fop.xsl"/><xsl:import href="plugin:com.agfa.radsol.dod:xsl/fo/topic.xsl"/><xsl:import href="plugin:com.agfa.radsol.dod:xsl/fo/links.xsl"/><xsl:import href="plugin:com.agfa.radsol.dod:xsl/fo/figlists.xsl"/><xsl:import href="plugin:com.agfa.radsol.dod:cfg/fo/attrs/figlists-attr.xsl"/>

  <xsl:import href="cfg:fo/attrs/custom.xsl"/>
  <xsl:import href="cfg:fo/xsl/custom.xsl"/>
  
</xsl:stylesheet>