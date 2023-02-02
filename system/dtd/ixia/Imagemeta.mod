<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA CMS Image                                    -->
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
PUBLIC "-//IXIA//ELEMENTS DITA CMS imagemeta//EN"
      Delivered as file "Imagemeta.mod"                            -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Define elements and specialization atttributed    -->
<!--             for images                                        -->
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


<!ENTITY % imagemeta-info-types "no-topic-nesting"                   >


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!ENTITY % imagemeta     "imagemeta"                                 >
<!ENTITY % imagebody     "imagebody"                                 >
<!ENTITY % imagedesc     "imagedesc"                                 >
<!ENTITY % imagetype     "imagetype"                                 >

<!-- For multi-images -->
<!ENTITY % images             "images"                               >
<!ENTITY % defaultformatname  "defaultformatname"                    >
<!ENTITY % imageinfo          "imageinfo"                            >
<!ENTITY % mime-type          "mime-type"                            >
<!ENTITY % formatname         "formatname"                           >
<!ENTITY % width              "width"                                >
<!ENTITY % height             "height"                               >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains ""                                         >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!--                    LONG NAME: Image Metadata                  -->
<!ELEMENT imagemeta     ((%title;), (%titlealts;)?,
                         (%shortdesc;)?, 
                         (%prolog;)?, (%imagebody;))*                >
<!ATTLIST imagemeta 
             id         ID                               #REQUIRED
             conref     CDATA                            #IMPLIED
             %select-atts;
             %localization-atts;
             %arch-atts;
             outputclass 
                        CDATA                            #IMPLIED
             domains    CDATA                "&included-domains;"    >

<!--                    LONG NAME: Image Body                      -->
<!ELEMENT imagebody     (%imagedesc;, %imagetype;, (%images;)?)      >
<!ATTLIST imagebody 
             %id-atts;
             %localization-atts;
             base       CDATA                            #IMPLIED
             %base-attribute-extensions;
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Image Description               -->
<!ELEMENT imagedesc    (%para.cnt;)*                                 >
<!ATTLIST imagedesc 
             %id-atts;
             conref     CDATA                            #IMPLIED
              %select-atts;
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Image Type                      -->
<!ELEMENT imagetype    (#PCDATA)*                                    >
<!ATTLIST imagetype 
             %id-atts;
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Image Group (for multi-images)  -->
<!ELEMENT images    (%defaultformatname;, (%imageinfo;)+)            >
<!ATTLIST images 
             compact    (yes | no)                       #IMPLIED
             spectitle  CDATA                            #IMPLIED
             %univ-atts;
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Default Format Name             -->
<!ELEMENT defaultformatname    (#PCDATA)*                            >
<!ATTLIST defaultformatname 
             %id-atts;
                 conref     CDATA                        #IMPLIED
              %select-atts;
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Image Information               -->
<!ELEMENT imageinfo    (%formatname;, %mime-type;, %width;, 
                        %height;)?                                   >
<!ATTLIST imageinfo 
             keyref     CDATA                            #IMPLIED
             %univ-atts;
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Image Mime Type                 -->
<!ELEMENT mime-type    (#PCDATA)*                                    >
<!ATTLIST mime-type 
             %id-atts;
                 conref     CDATA                        #IMPLIED
              %select-atts;
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Format Name                     -->
<!ELEMENT formatname    (#PCDATA)*                                   >
<!ATTLIST formatname 
             %id-atts;
                 conref     CDATA                        #IMPLIED
              %select-atts;
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Image Width                     -->
<!ELEMENT width    (#PCDATA)*                                        >
<!ATTLIST width 
             %id-atts;
             conref     CDATA                            #IMPLIED
             %select-atts;
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >

<!--                    LONG NAME: Image Height                    -->
<!ELEMENT height    (#PCDATA)*     >
<!ATTLIST height 
             %id-atts;
             conref     CDATA                            #IMPLIED
             %select-atts;
             xml:lang   NMTOKEN                          #IMPLIED
             outputclass 
                        CDATA                            #IMPLIED    >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST imagemeta          %global-atts; class CDATA "- topic/topic imagemeta/imagemeta " >
<!ATTLIST imagebody          %global-atts; class CDATA "- topic/body  imagemeta/imagebody " >
<!ATTLIST imagedesc	         %global-atts;  class CDATA "- topic/p imagemeta/imagedesc " >
<!ATTLIST imagetype	         %global-atts; class CDATA "- topic/p imagemeta/imagetype " >
<!ATTLIST images	         %global-atts; class CDATA "- topic/ul imagemeta/images " >

<!ATTLIST defaultformatname	 %global-atts; class CDATA "- topic/ph imagemeta/defaultformatname " >
<!ATTLIST imageinfo	         %global-atts; class CDATA "- topic/li imagemeta/imageinfo " >

<!ATTLIST formatname	     %global-atts; class CDATA "- topic/ph imagemeta/formatname " >
<!ATTLIST mime-type	         %global-atts; class CDATA "- topic/ph imagemeta/mime-type " >
<!ATTLIST width	             %global-atts; class CDATA "- topic/ph imagemeta/width " >
<!ATTLIST height	         %global-atts; class CDATA "- topic/ph imagemeta/height " >


<!-- ================== End DITA CMS Image  ========================== -->