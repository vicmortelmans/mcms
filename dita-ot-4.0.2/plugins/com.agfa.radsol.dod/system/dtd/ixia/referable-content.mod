<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA Referable-Content                            -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      February 2008				                       -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identfier or an 
      appropriate system identifier 
PUBLIC "-//IXIA//ELEMENTS DITA Referable-Content//EN"
      Delivered as file "referable-content.mod"                    -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Define elements and specialization atttributed    -->
<!--             for referable content                             -->
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
<!--                    STRUCTURAL MEMBERS                         -->
<!-- ============================================================= -->


<!ENTITY % info-types    'no-topic-nesting'                          > 


<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % referable-content  "referable-content"                    >
<!ENTITY % rcbody             "rcbody"                               >


<!-- ============================================================= -->
<!--                    SHARED ATTRIBUTE LISTS                     -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains ""                                         >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!--                    LONG NAME: Referable-Content               -->
<!ELEMENT referable-content   ((%title;), (%titlealts;)?,
                              (%shortdesc; | %abstract;)?, 
                              (%prolog;)?, (%rcbody;)?, 
                              (%related-links;)?, (%info-types;)*)   >
<!ATTLIST referable-content
             id         ID                                 #REQUIRED
             conref     CDATA                              #IMPLIED
             %select-atts;
             %localization-atts;
             outputclass 
                        CDATA                              #IMPLIED
             %arch-atts;
             domains    CDATA                    "&included-domains;">


<!--                    LONG NAME: Referable-Content Body          -->
<!ELEMENT rcbody ANY                                                 >
<!ATTLIST rcbody            
             %univ-atts;
             outputclass 
                        CDATA                            #IMPLIED    >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST referable-content  %global-atts; class CDATA "- topic/topic referable-content/referable-content " >
<!ATTLIST rcbody             %global-atts; class CDATA "- topic/body referable-content/body " >


<!-- ================== End DITA Referable-Content  ============== -->