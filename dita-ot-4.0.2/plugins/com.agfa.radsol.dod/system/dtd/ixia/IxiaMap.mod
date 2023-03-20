<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA IxiaMap                                      -->
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
PUBLIC "-//IXIA//ELEMENTS IXIA DITA Map//EN"
      Delivered as file "IxiaMap.mod"                              -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Define elements and specialization atttributed    -->
<!--             for Ixiasoft map specialization                   -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->

<!-- default namespace prefix for DITAArchVersion attribute can be
     overridden through predefinition in the document type shell   -->
<!ENTITY % DITAArchNSPrefix
  "ditaarch"
>

<!-- must be instanced on each topic type                          -->
<!ENTITY % arch-atts 
             "xmlns:%DITAArchNSPrefix; 
                        CDATA
                                  #FIXED 'http://dita.oasis-open.org/architecture/2005/'
              %DITAArchNSPrefix;:DITAArchVersion
                        CDATA
                                  '1.2'
  "
>

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!ENTITY % ixiamap           "ixiamap"                               >
<!ENTITY % enhancedtopicmeta "enhancedtopicmeta"                     >
<!ENTITY % vardefs           "vardefs"                               >
<!ENTITY % vardef            "vardef"                                >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!ENTITY included-domains 
  "" 
>
 
<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!--                    LONG NAME: Ixia Map                        -->
<!ENTITY % ixiamap.content
                       "((%title;)?, 
                         (%enhancedtopicmeta;)?, 
                         (%anchor; |
                          %data.elements.incl; |
                          %navref; |
                          %reltable; |
                          %topicref;)* )"
>
<!ELEMENT ixiamap       %ixiamap.content;                             >
<!ATTLIST ixiamap    
              %map.attributes;
              %arch-atts;
              domains 
                        CDATA 
                                  "&included-domains;" 
>

<!--                    LONG NAME: Enhanced Topic Metadata         -->
<!--                    LONG NAME: Topic Metadata                  -->
<!ENTITY % enhancedtopicmeta.content
                       "((%navtitle;)?,
                         (%linktext;)?, 
                         (%searchtitle;)?, 
                         (%shortdesc;)?, 
                         (%author;)*, 
                         (%source;)?, 
                         (%publisher;)?, 
                         (%copyright;)*, 
                         (%critdates;)?, 
                         (%permissions;)?, 
                         (%metadata;)*, 
                         (%audience;)*, 
                         (%category;)*, 
                         (%keywords;)*, 
                         (%vardefs;)?, 
                         (%prodinfo;)*, 
                         (%othermeta;)*, 
                         (%resourceid;)*, 
                         (%data.elements.incl; | 
                          %foreign.unknown.incl;)*)"
>
<!ELEMENT enhancedtopicmeta    %enhancedtopicmeta.content;           >
<!ATTLIST enhancedtopicmeta    %topicmeta.attributes;                >

<!--                    LONG NAME: Variable Definitions            -->
<!ELEMENT vardefs       (%vardef;)*                                  >

<!--                    LONG NAME: Variable Definition             -->
<!ELEMENT vardef        %keyword.content;                            >
<!ATTLIST vardef        %keyword.attributes;                         >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST ixiamap            %global-atts; class CDATA "- map/map ixiamap/map " >
<!ATTLIST enhancedtopicmeta  %global-atts; class CDATA "- map/topicmeta ixiamap/enhancedmetadata " >
<!ATTLIST vardefs            %global-atts; class CDATA "- topic/keywords ixiamap/vardefs " >
<!ATTLIST vardef             %global-atts; class CDATA "- topic/keyword  ixiamap/vardef " >


<!-- ================== End DITA IxiaMap  ======================== -->