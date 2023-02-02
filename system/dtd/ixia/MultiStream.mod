<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA CMS Multistream Content                      -->
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
PUBLIC "-//IXIA//ELEMENTS DITA CMS multistream//EN"
      Delivered as file "MultiStream.mod"                          -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Define elements and specialization atttributed    -->
<!--             for objects with mutliple content stream          -->
<!--             such as images and resources                      -->
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


<!ENTITY % multistream-info-types "no-topic-nesting"                 >


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!ENTITY % multistream        "multistream"                          >
<!ENTITY % streambody         "streambody"                           >
<!-- element for extention -->
<!ENTITY % streamproperty     "streamproperty"                       >

<!ENTITY % streamcontent      "streamcontent"                        >
<!ENTITY % streamitem         "streamitem"                           >
<!ENTITY % itemname           "itemname"                             >
<!ENTITY % itemmime-type      "itemmime-type"                        >
<!-- element for extention -->
<!ENTITY % itemproperty       "itemproperty"                         >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains ""                                         >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- This DITA class is not intended to be used directly, it       -->
<!-- should be used as a base for specialisations like resources   -->
<!-- or multi-images (yet to be converted).                        -->

<!--                    LONG NAME: Multi-Stream                    -->
<!ELEMENT multistream  (%title;, (%titlealts;)?, (%shortdesc;)?, 
                         (%prolog;)?, (%streambody;))                >
<!ATTLIST multistream 
             id         ID                               #REQUIRED
             conref     CDATA                            #IMPLIED
             %select-atts;
             xml:lang   NMTOKEN                          #IMPLIED
             %arch-atts;
             outputclass 
                        CDATA                            #IMPLIED
             domains    CDATA                "&included-domains;"    >

<!--                    LONG NAME: Stream Body                     -->
<!ELEMENT streambody   ((%streamproperty;)*, %streamcontent;)        >
<!ATTLIST streambody 
             %id-atts;
             conref     CDATA                            #IMPLIED
              %select-atts;
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Stream properties               -->
<!ELEMENT streamproperty    (#PCDATA)*                               >
<!ATTLIST streamproperty 
             %id-atts;
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Stream content                  -->
<!ELEMENT streamcontent    ((%streamitem;)+)                         >
<!ATTLIST streamcontent 
             compact    (yes | no)                       #IMPLIED
             spectitle  CDATA                            #IMPLIED
             %univ-atts;
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Stream content item             -->
<!ELEMENT streamitem    ( %itemname;, ((%itemmime-type;, 
                          (%itemproperty;)*) | ((%itemproperty;)*, 
                          %streamcontent;)))                         >
<!ATTLIST streamitem 
             keyref     CDATA                           #IMPLIED
             %univ-atts;
             outputclass 
                        CDATA                            #IMPLIED    >

<!ELEMENT itemname    (#PCDATA)*                                     >
<!ATTLIST itemname 
             %id-atts;
             conref     CDATA                            #IMPLIED
             %select-atts;
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!ELEMENT itemmime-type    (#PCDATA)*                                >
<!ATTLIST itemmime-type 
             %id-atts;
             conref     CDATA                            #IMPLIED
             %select-atts;
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!ELEMENT itemproperty    (#PCDATA)*                                 >
<!ATTLIST itemproperty  
             %id-atts;
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST multistream     %global-atts; class CDATA "- topic/topic multistream/multistream " >
<!ATTLIST streambody      %global-atts; class CDATA "- topic/body multistream/streambody " >
<!ATTLIST streamproperty  %global-atts; class CDATA "- topic/ph multistream/streamproperty " >

<!ATTLIST streamcontent   %global-atts; class CDATA "- topic/ul multistream/streamcontent " >
<!ATTLIST streamitem	  %global-atts; class CDATA "- topic/li multistream/streamitem " >
<!ATTLIST itemname        %global-atts; class CDATA "- topic/ph multistream/itemname " >
<!ATTLIST itemmime-type	  %global-atts; class CDATA "- topic/ph multistream/itemmime-type " >
<!ATTLIST itemproperty    %global-atts; class CDATA "- topic/ph multistream/itemproperty " >


<!-- ================== End DITA CMS Multistream Content  ======== -->