<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA project                                      -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      2007-08-08                                        -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identfier or an 
      appropriate system identifier 
PUBLIC "-//IXIA//ELEMENTS DITA CMS project//EN"
      Delivered as file "project.mod"                              -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Define elements and specialization atttributed    -->
<!--             for projects                                      -->
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


<!ENTITY % project-info-types "no-topic-nesting"                     >


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!ENTITY % project            "project"                              >
<!ENTITY % projectbody        "projectbody"                          >
<!ENTITY % settings           "settings"                             >
<!ENTITY % bulletinboard      "bulletinboard"                        >
<!ENTITY % message            "message"                              >
<!ENTITY % date               "date"                                 >
<!ENTITY % messagetitle       "messagetitle"                         >
<!ENTITY % messagebody        "messagebody"                          >
<!ENTITY % visible            "visible"                              >
<!ENTITY % team               "team"                                 >
<!ENTITY % member             "member"                               >
<!ENTITY % defaultmilestones  "defaultmilestones"                    >
<!ENTITY % defaulttranslation "defaulttranslation"                   >
<!ENTITY % language           "language"                             >
<!ENTITY % votingdefaults     "votingdefaults"                       >
<!ENTITY % roledefault        "roledefault"                          >
<!ENTITY % votingsystem       "votingsystem"                         >
<!ENTITY % defaultmembers     "defaultmembers"                       >
<!ENTITY % role               "role"                                 >
<!ENTITY % deliverables       "deliverables"                         >
<!ENTITY % deliverable        "deliverable"                          >
<!ENTITY % fullpath           "fullpath"                             >
<!ENTITY % maps               "maps"                                 >
<!ENTITY % map                "map"                                  >
<!ENTITY % mapfullpath        "mapfullpath"                          >
<!ENTITY % milestones         "milestones"                           >
<!ENTITY % statemilestone     "statemilestone"                       >
<!ENTITY % statename          "statename"                            >
<!ENTITY % startdate          "startdate"                            >
<!ENTITY % duedate            "duedate"                              >
<!ENTITY % enddate            "enddate"                              >
<!ENTITY % comment            "comment"                              >
<!ENTITY % translation        "translation"                          >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains ""                                         >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!--                    LONG NAME: project                         -->
<!ELEMENT project       (%title;, %prolog;, %projectbody;)           >
<!ATTLIST project
             xml:lang   NMTOKEN                          #IMPLIED
             id         ID                               #REQUIRED   >


<!--                    LONG NAME: project Body                    -->
<!ELEMENT projectbody   (%settings;, (%deliverables;|%maps;))        >

<!--                    LONG NAME: project's context               -->
<!ELEMENT settings      ((%startdate;|%duedate;|%bulletinboard;|%team;| 
                         %defaulttranslation;|%votingdefaults;|
                         %defaultmembers;|%defaultmilestones;)*)     >
<!ELEMENT startdate      (#PCDATA)                                   >
<!ELEMENT duedate        (#PCDATA)                                   >
<!ELEMENT bulletinboard    ((%message;)*)                            >
<!ELEMENT message          (%date;,%member;,%messagetitle;,
                            %messagebody;,%visible;)                 >
<!ELEMENT date             (#PCDATA)                                 >
<!ELEMENT messagetitle     (#PCDATA)                                 >
<!ELEMENT messagebody      (#PCDATA)                                 >
<!ELEMENT visible          (#PCDATA)                                 >

<!ELEMENT team             ((%member;)*)                             >
<!ELEMENT member           (#PCDATA)                                 >

<!ELEMENT defaultmilestones    ((%statemilestone;)*)                 >
<!ELEMENT defaulttranslation    ((%language;)*)                      >
<!ELEMENT language         EMPTY                                     >
<!ATTLIST language 
             xml:lang      NMTOKEN                       #REQUIRED   >

<!ELEMENT votingdefaults    ((%roledefault;)*)                       >
<!ELEMENT roledefault       (%role;, ((%member;)+|%votingsystem;))   >
<!ELEMENT role              (#PCDATA)                                >
<!ELEMENT votingsystem      (#PCDATA)                                >

<!ELEMENT defaultmembers    ((%roledefault;)*)                       >

<!ELEMENT deliverables     ((%deliverable;)*)                        >
<!ELEMENT deliverable      (%fullpath;, %milestones;,
                            %translation;)                           >
<!ELEMENT fullpath         (#PCDATA)                                 >

<!ELEMENT maps             ((%map;)*)                                >
<!ELEMENT map              (%mapfullpath;, %milestones;,
                            %translation;)                           >
<!ELEMENT mapfullpath      (#PCDATA)                                 >
<!ELEMENT milestones       ((%statemilestone;)*)                     >
<!ELEMENT statemilestone   (%statename;, %duedate;, (%enddate;)?,
                                                    (%comment;)?)    >
<!ELEMENT statename        (#PCDATA)                                 >
<!ELEMENT enddate          (#PCDATA)                                 >
<!ELEMENT comment          (#PCDATA)                                 >

<!ELEMENT translation      ((%language;)*)                           >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST project             %global-atts; class CDATA "- topic/topic task/task project/project " >
<!ATTLIST projectbody         %global-atts; class CDATA "- topic/body task/taskbody project/projectbody " >
<!ATTLIST settings            %global-atts; class CDATA "- topic/section task/context project/settings " >
<!ATTLIST bulletinboard       %global-atts; class CDATA "- topic/ol project/bulletinboard " >
<!ATTLIST message             %global-atts; class CDATA "- topic/li project/message " >
<!ATTLIST date                %global-atts; class CDATA "- topic/p project/date " >
<!ATTLIST messagetitle        %global-atts; class CDATA "- topic/p project/messagetitle " >
<!ATTLIST messagebody         %global-atts; class CDATA "- topic/p project/messagebody " >
<!ATTLIST visible             %global-atts; class CDATA "- topic/p project/visible " >
<!ATTLIST team                %global-atts; class CDATA "- topic/ul project/team " >
<!ATTLIST member              %global-atts; class CDATA "- topic/li project/member " >
<!ATTLIST defaultmilestones    %global-atts;  class CDATA "- topic/ul project/defaultmilestones ">
<!ATTLIST defaulttranslation  %global-atts; class CDATA "- topic/ul project/defaulttranslation " >
<!ATTLIST language            %global-atts; class CDATA "- topic/li project/language " >
<!ATTLIST votingdefaults      %global-atts; class CDATA "- topic/ul project/votingdefaults " >
<!ATTLIST votingsystem        %global-atts; class CDATA "- topic/p project/votingsystem " >
<!ATTLIST defaultmembers      %global-atts; class CDATA "- topic/ul project/defaultmembers " >
<!ATTLIST roledefault         %global-atts; class CDATA "- topic/li project/roledefault " >
<!ATTLIST role                %global-atts; class CDATA "- topic/p project/role " >

<!ATTLIST deliverables        %global-atts; class CDATA "- topic/ul task/steps-unordered project/deliverables " >
<!ATTLIST deliverable         %global-atts; class CDATA "- topic/li task/step project/deliverable " >
<!ATTLIST fullpath            %global-atts; class CDATA "- topic/ph task/cmd project/fullpath " >

<!ATTLIST maps                %global-atts; class CDATA "- topic/ul task/steps-unordered project/deliverables project/maps " >
<!ATTLIST map                 %global-atts; class CDATA "- topic/li task/step project/deliverable project/map " >
<!ATTLIST mapfullpath         %global-atts; class CDATA "- topic/ph task/cmd project/fullpath project/mapfullpath " >

<!ATTLIST milestones          %global-atts; class CDATA "- topic/ol task/substeps project/milestones " >
<!ATTLIST statemilestone      %global-atts; class CDATA "- topic/li task/substep project/statemilestone " >
<!ATTLIST statename           %global-atts; class CDATA "- topic/itemgroup task/info project/statename " >
<!ATTLIST startdate            %global-atts;  class CDATA "- topic/itemgroup task/info project/startdate ">
<!ATTLIST duedate             %global-atts; class CDATA "- topic/itemgroup task/info project/duedate " >
<!ATTLIST enddate             %global-atts; class CDATA "- topic/itemgroup task/info project/enddate " >
<!ATTLIST comment             %global-atts; class CDATA "- topic/itemgroup task/info project/comment " >
<!ATTLIST translation         %global-atts; class CDATA "- topic/ul project/translation " >


<!-- ================== End DITA CMS Project  ==================== -->