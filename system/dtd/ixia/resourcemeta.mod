<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA CMS Resource                                 -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      January                                           -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//IXIA//ELEMENTS DITA CMS resourcemeta//EN"
      Delivered as file "resourcemeta.mod"                         -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Define elements and specialization atttributed    -->
<!--             for resources                                     -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             March 2001                                        -->
<!--                                                               -->
<!--             (C) Copyright OASIS Open 2005.                    -->
<!--             (C) Copyright IBM Corporation 2001, 2004.         -->
<!--             All Rights Reserved.                              -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->

<!-- default namespace prefix for DITAArchVersion attribute can be
     overridden through predefinition in the document type shell   -->
<!ENTITY % DITAArchNSPrefix
                       "ditaarch"                                    >

<!-- must be instanced on each topic type                          -->
<!ENTITY % arch-atts "
             xmlns:%DITAArchNSPrefix; 
                        CDATA                              #FIXED
                       'http://dita.oasis-open.org/architecture/2005/'
             %DITAArchNSPrefix;:DITAArchVersion
                        CDATA                              '1.1'"    >


<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->


<!ENTITY % resourcemeta-info-types "no-topic-nesting"                >


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!ENTITY % resourcemeta       "resourcemeta"                         >
<!ENTITY % resourcebody       "resourcebody"                         >
<!ENTITY % resourcetype       "resourcetype"                         >

<!ENTITY % resourcecontent    "resourcecontent"                      >
<!ENTITY % defaultitem        "defaultitem"                          >
<!ENTITY % resourceitem       "resourceitem"                         >
<!ENTITY % resourceitemdesc   "resourceitemdesc"                     >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains ""                                         >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!--                    LONG NAME: Resource                        -->
<!ELEMENT resourcemeta  (%title;, (%titlealts;)?, (%shortdesc;)?, 
                         (%prolog;)?, (%resourcebody;))              >
<!ATTLIST resourcemeta        
             id         ID                               #REQUIRED
             conref     CDATA                            #IMPLIED
             %select-atts;
             xml:lang   NMTOKEN                          #IMPLIED
             %arch-atts;
             outputclass 
                        CDATA                            #IMPLIED
             domains    CDATA                "&included-domains;"    >


<!--                    LONG NAME: Resource Body                   -->
<!ELEMENT resourcebody   (%resourcetype;, (%streamproperty;)*, 
                          %resourcecontent;)                         >
<!ATTLIST resourcebody 
             %id-atts;
             conref     CDATA                            #IMPLIED
              %select-atts;
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Resource type                   -->
<!ELEMENT resourcetype    (#PCDATA)*                                 >
<!ATTLIST resourcetype 
             %id-atts;
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Stream content                  -->
<!ELEMENT resourcecontent    (%defaultitem;, (%resourceitem;)+)      >
<!ATTLIST resourcecontent        
             compact    (yes | no)                       #IMPLIED
             spectitle  CDATA                            #IMPLIED
             %univ-atts;
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Default item                    -->
<!ELEMENT defaultitem    (#PCDATA)                                   >
<!ATTLIST defaultitem 
             keyref     CDATA                           #IMPLIED
             %univ-atts;
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Stream content item             -->
<!ELEMENT resourceitem    ( %itemname;, ((%itemmime-type;, 
                           (%resourceitemdesc;)?, (%itemproperty;)*) |
                           ((%resourceitemdesc;)?, (%itemproperty;)*,
                           %resourcecontent;)) )                     >
<!ATTLIST resourceitem 
             keyref     CDATA                           #IMPLIED
             %univ-atts;
             outputclass 
                        CDATA                            #IMPLIED    >

<!ELEMENT resourceitemdesc    (#PCDATA)*                             >
<!ATTLIST resourceitemdesc 
             %id-atts;
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST resourcemeta      %global-atts; class CDATA "- topic/topic multistream/multistream resourcemeta/resourcemeta " >
<!ATTLIST resourcebody      %global-atts; class CDATA "- topic/body multistream/streambody resourcemeta/resourcebody " >
<!ATTLIST resourcetype      %global-atts; class CDATA "- topic/ph multistream/streamproperty resourcemeta/resourcetype " >

<!ATTLIST resourcecontent   %global-atts; class CDATA "- topic/ul multistream/streamcontent resourcemeta/resourcecontent " >
<!ATTLIST defaultitem       %global-atts; class CDATA "- topic/ph multistream/streamproperty resourcemeta/defaultitem " >
<!ATTLIST resourceitem	    %global-atts; class CDATA "- topic/li multistream/streamitem resourcemeta/resourceitem " >
<!ATTLIST resourceitemdesc  %global-atts; class CDATA "- topic/ph multistream/itemproperty resourcemeta/resourceitemdesc " >


<!-- ================== End DITA CMS Resource  =================== -->