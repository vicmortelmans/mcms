<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA Resource Package                             -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:                                                        -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//IXIA//ELEMENTS IXIA DITA Resource Package//EN"
      Delivered as file "IxiaResourcePackage.mod"                  -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Define elements and specialization atttributed    -->
<!--             for Ixiasoft map specialization                   -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!ENTITY % resourcepkg      "resourcepkg"                            >
<!ENTITY % resourceref    	"resourceref"                            >
<!ENTITY % resourcemeta     "resourcemeta"                           >
<!ENTITY % vardefs          "vardefs"                                >
<!ENTITY % vardef           "vardef"                                 >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains ""                                         >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!ELEMENT  resourcepkg   ((%title;)?, (%resourcemeta;)?, 
                         (%navref; | %anchor; | %resourceref; | 
                         %reltable; | %data.elements.incl;)* )       >

<!ATTLIST  resourcepkg 
             title      CDATA                             #IMPLIED
             id         ID                                #IMPLIED
             anchorref  CDATA                             #IMPLIED
             translate  (yes | no)                        #IMPLIED
             xml:lang   NMTOKEN                           #IMPLIED
             %arch-atts;
             domains    CDATA                  "&included-domains;" 
             %topicref-atts;
             %select-atts;                                           >

<!ELEMENT resourcemeta ((%shortdesc;)?, (%audience;)*, (%category;)*,
                        (%keywords;, %vardefs;), (%prodinfo;)*, 
                        (%othermeta;)*)                              >
<!ATTLIST resourcemeta
              mapkeyref CDATA                             #IMPLIED   >

<!ELEMENT vardefs (%vardef;)*                                        >

<!ELEMENT vardef  (#PCDATA)                                          >
<!ATTLIST vardef
					 %id-atts;
					 %select-atts;
					 translate (yes | no)              #IMPLIED
					 xml:lang NMTOKEN              #IMPLIED          >

<!ELEMENT  resourceref     ((%topicmeta;)?, ( %resourceref;)* )      >
<!ATTLIST  resourceref
             navtitle   CDATA                             #IMPLIED
             href       CDATA                             #IMPLIED
             keyref     CDATA                             #IMPLIED
             keys       CDATA                             #IMPLIED
             query      CDATA                             #IMPLIED
             copy-to    CDATA                             #IMPLIED
             outputclass 
                        CDATA                             #IMPLIED
             %topicref-atts;
             %univ-atts;                                             >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST resourcepkg   %global-atts; class CDATA "- map/map resourcepkg/map " >
<!ATTLIST resourcemeta  %global-atts; class CDATA "- map/topicmeta resourcepkg/resourcemeta " >
<!ATTLIST vardefs       %global-atts; class CDATA "- topic/keywords resourcepkg/vardefs " >
<!ATTLIST vardef        %global-atts; class CDATA "- topic/keyword  resourcepkg/vardef " >
<!ATTLIST resourceref   %global-atts; class CDATA "- map/topicref resourcepkg/resourceref " >


<!-- ================== End DITA Resource Package  =============== -->