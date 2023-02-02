<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA CMS Formatted                                -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      January                                           -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identfier or an 
      appropriate system identifier 
PUBLIC "-//IXIA//ELEMENTS DITA CMS formatted//EN"
      Delivered as file "formatted.mod"                            -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Define elements and specialization atttributed    -->
<!--             for formatted objects                             -->
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


<!ENTITY % formatted-info-types "no-topic-nesting"                   >


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!ENTITY % formatted         "formatted"                             >
<!ENTITY % formattedbody     "formattedbody"                         >
<!ENTITY % formatteddesc     "formatteddesc"                         >
<!ENTITY % formattedvars     "formattedvars"                         >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains ""                                         >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!--                    LONG NAME: formatted                       -->
<!ELEMENT formatted       (%title;, (%titlealts;)?, (%shortdesc;)?, 
                         (%prolog;)?, (%formattedbody;))*            >
<!ATTLIST formatted 
             id         ID                               #REQUIRED
             conref     CDATA                            #IMPLIED
             %select-atts;
             xml:lang   NMTOKEN                          #IMPLIED
             %arch-atts;
             outputclass 
                        CDATA                            #IMPLIED
             domains    CDATA                "&included-domains;"    >

<!--                    LONG NAME: formatted Body                  -->
<!ELEMENT formattedbody       (%formatteddesc;, %formattedvars;)     >
<!ATTLIST formattedbody 
             %id-atts;
             conref     CDATA                            #IMPLIED
              %select-atts;
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: formatted description           -->
<!ELEMENT formatteddesc    (%para.cnt;)*                             >
<!ATTLIST formatteddesc 
             %id-atts;
             conref     CDATA                            #IMPLIED
              %select-atts;
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: formatted vars                  -->
<!ELEMENT formattedvars    (%para.cnt;)*                             >
<!ATTLIST formattedvars 
             %id-atts;
             conref     CDATA                            #IMPLIED
              %select-atts;
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST formatted      %global-atts; class CDATA "- topic/topic formatted/formatted " >
<!ATTLIST formattedbody  %global-atts; class CDATA "- topic/body  formatted/formattedbody " >
<!ATTLIST formatteddesc	 %global-atts; class CDATA "- topic/p formatted/formatteddesc " >
<!ATTLIST formattedvars	 %global-atts; class CDATA "- topic/p formatted/formattedvars " >


<!-- ================== End DITA CMS Formatted  ================== -->