<!-- ============================================================= -->
<!--                                                               -->
<!--  (c) 2008 Justsystems Canada Inc. All Rights Reserved         -->
<!--                                                               -->
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA Component                                    -->
<!--  VERSION:   1.1                                               -->
<!--  DATE:      April 2008				                           -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identfier
 
PUBLIC "-//XMETAL//ELEMENTS DITA Component//EN"

OR

PUBLIC "-//XMETAL//ELEMENTS DITA 1.1 Component//EN"

      Delivered as file "ditacomponent.mod"                        -->

<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->
<!-- default namespace prefix for DITAArchVersion attribute can be
     overridden through predefinition in the document type shell   -->
<!ENTITY % DITAArchNSPrefix "ditaarch">
<!-- must be instanced on each topic type                          -->
<!ENTITY % arch-atts "
             xmlns:%DITAArchNSPrefix; 
                        CDATA
                       'http://dita.oasis-open.org/architecture/2005/'
             %DITAArchNSPrefix;:DITAArchVersion
                        CDATA
                       '1.1'">
<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
<!ENTITY % ditacomponent "ditacomponent">
<!ENTITY % compbody "compbody">
<!ENTITY % reusable-content "reusable-content">
<!ENTITY % description "description">
<!-- ============================================================= -->
<!--                    SHARED ATTRIBUTE LISTS                     -->
<!-- ============================================================= -->
<!--                    Provide an alternative set of univ-atts 
                        that allows importance to be redefined 
                        locally                                    -->
<!ENTITY % univ-atts-no-importance-task '%id-atts;
             platform   CDATA                            #IMPLIED
             product    CDATA                            #IMPLIED
             audience   CDATA                            #IMPLIED
             otherprops CDATA                            #IMPLIED
             rev        CDATA                            #IMPLIED
             status     (new | changed | deleted |   
                         unchanged)                      #IMPLIED
             translate  (yes | no)                       #IMPLIED
             xml:lang   NMTOKEN                          #IMPLIED'>
<!ENTITY % comp-info-types "%info-types;">
<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->
<!ENTITY included-domains "">
<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->
<!--                    LONG NAME: Component                       -->
<!ELEMENT ditacomponent  (  (%description;), (%prolog;)?, (%compbody;))>
<!ATTLIST ditacomponent
	id ID #REQUIRED
	conref CDATA #IMPLIED
	%select-atts; 
	xml:lang NMTOKEN #IMPLIED
	%arch-atts; 
	outputclass CDATA #IMPLIED
	domains CDATA "&included-domains;"
>


<!--                    LONG NAME: Description                          -->
<!ELEMENT description (%title.cnt;)*>
<!ATTLIST description
	%univ-atts; 
	outputclass CDATA #IMPLIED  >
	
<!--                    LONG NAME: Component Body                       -->
<!ELEMENT compbody (%required-cleanup;|%reusable-content;)?>
<!ATTLIST compbody
	%id-atts; 
	translate (yes | no) #IMPLIED
	xml:lang NMTOKEN #IMPLIED
	outputclass CDATA #IMPLIED
>

<!--                    LONG NAME: Reusable Content                     -->
<!ELEMENT reusable-content ANY >
<!--  (concept
                           |conbody
                           |dita
                           |b
                           |u
                           |i
                           |tt
                           |sup
                           |sub
                           |keyword
                           |map
                           |navref
                           |topicref
                           |anchor
                           |reltable
                           |relheader
                           |relcolspec
                           |relrow
                           |relcell
                           |topicmeta
                           |linktext
                           |searchtitle
                           |shortdesc
                           |topichead
                           |topicgroup
                           |author
                           |source
                           |publisher
                           |copyright
                           |copyryear
                           |copyrholder
                           |critdates
                           |created
                           |revised
                           |permissions
                           |category
                           |audience
                           |keywords
                           |prodinfo
                           |prodname
                           |vrmlist
                           |vrm
                           |brand
                           |series
                           |platform
                           |prognum
                           |featnum
                           |component
                           |othermeta
                           |resourceid
                           |indexterm
                           |codeph
                           |codeblock
                           |option
                           |var
                           |parmname
                           |synph
                           |oper
                           |delim
                           |sep
                           |apiname
                           |parml
                           |plentry
                           |pt
                           |pd
                           |syntaxdiagram
                           |synblk
                           |groupseq
                           |groupchoice
                           |groupcomp
                           |fragment
                           |fragref
                           |synnote
                           |synnoteref
                           |repsep
                           |kwd
                           |reference
                           |refbody
                           |refsyn
                           |properties
                           |prophead
                           |proptypehd
                           |propvaluehd
                           |propdeschd
                           |property
                           |proptype
                           |propvalue
                           |propdesc
                           |msgph
                           |msgblock
                           |msgnum
                           |cmdname
                           |varname
                           |filepath
                           |userinput
                           |systemoutput
                           |task
                           |taskbody
                           |prereq
                           |context
                           |steps
                           |steps-unordered
                           |step
                           |cmd
                           |info
                           |substeps
                           |substep
                           |tutorialinfo
                           |stepxmp
                           |choices
                           |choice
                           |choicetable
                           |chhead
                           |choptionhd
                           |chdeschd
                           |chrow
                           |choption
                           |chdesc
                           |stepresult
                           |result
                           |postreq
                           |ph
                           |title
                           |table
                           |tgroup
                           |colspec
                           |spanspec
                           |thead
                           |tfoot
                           |tbody
                           |row
                           |entry
                           |topic
                           |titlealts
                           |navtitle
                           |body
                           |section
                           |example
                           |desc
                           |prolog
                           |metadata
                           |p
                           |note
                           |lq
                           |q
                           |sl
                           |sli
                           |ul
                           |ol
                           |li
                           |itemgroup
                           |dl
                           |dlhead
                           |dthd
                           |ddhd
                           |dlentry
                           |dt
                           |dd
                           |fig
                           |figgroup
                           |pre
                           |lines
                           |term
                           |tm
                           |boolean
                           |state
                           |image
                           |alt
                           |object
                           |param
                           |simpletable
                           |sthead
                           |strow
                           |stentry
                           |draft-comment
                           |required-cleanup
                           |fn
                           |indextermref
                           |cite
                           |xref
                           |related-links
                           |link
                           |linklist
                           |linkinfo
                           |linkpool
                           |uicontrol
                           |wintitle
                           |menucascade
                           |shortcut
                           |screen
                           |imagemap
                           |area
                           |shape
                           |coords
                           |%specialized-typemods-element-orlist;)
-->
<!ATTLIST reusable-content 
    %global-atts;
    ixia_locid CDATA #IMPLIED
    class CDATA "- topic/required-cleanup ditacomponent/reusable-component "
>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->
<!ATTLIST ditacomponent
	%global-atts; 
	class CDATA "- topic/topic ditacomponent/ditacomponent "
>
<!ATTLIST compbody
	%global-atts; 
	class CDATA "- topic/body ditacomponent/compbody "
>
<!ATTLIST description
	%global-atts; 
	class CDATA "- topic/title ditacomponent/description "
>

<!-- ================== End DITA Task  =========================== -->
