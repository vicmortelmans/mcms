<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA Strict Taskbody Constraint                   -->
<!--  VERSION:   1.2                                               -->
<!--  DATE:      November 2009                                     -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//IXIA//ELEMENTS IXIA DITA 1.2 Strict Section Constraint//EN"
      Delivered as file "strictSectionConstraint.mod"              -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the domain entity for the strict task   -->
<!--             constraint module                                 -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             April 2008                                        -->
<!--                                                               -->
<!--             (C) Copyright OASIS Open 2008, 2009.              -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!--  UPDATES:                                                     -->
<!-- ============================================================= -->



<!-- ============================================================= -->
<!--                    Strict Taskbody ENTITIES                   -->
<!-- ============================================================= -->

<!ENTITY section-constraints     
                        "(topic strictSection-c)"                    >

<!--                    Redeclare the element entities needed for
                        the section                                -->
<!ENTITY % boolean      "boolean"                                    >
<!ENTITY % cite         "cite"                                       >
<!ENTITY % data         "data"                                       >
<!ENTITY % data-about   "data-about"                                 >
<!ENTITY % draft-comment 
                        "draft-comment"                              >
<!ENTITY % dl           "dl"                                         >
<!ENTITY % fig          "fig"                                        >
<!ENTITY % fn           "fn"                                         >
<!ENTITY % foreign      "foreign"                                    >
<!ENTITY % image        "image"                                      >
<!ENTITY % indexterm    "indexterm"                                  >
<!ENTITY % indextermref "indextermref"                               >
<!ENTITY % keyword      "keyword"                                    >
<!ENTITY % lines        "lines"                                      >
<!ENTITY % lq           "lq"                                         >
<!ENTITY % note         "note"                                       >
<!ENTITY % object       "object"                                     >
<!ENTITY % ol           "ol"                                         >
<!ENTITY % p            "p"                                          > 
<!ENTITY % ph           "ph"                                         >
<!ENTITY % pre          "pre"                                        >
<!ENTITY % q            "q"                                          >
<!ENTITY % required-cleanup     
                        "required-cleanup"                           >
<!ENTITY % sectiondiv   "sectiondiv"                                 >
<!ENTITY % simpletable  "simpletable"                                >
<!ENTITY % sl           "sl"                                         > 
<!ENTITY % state        "state"                                      >
<!ENTITY % table        "table"                                      >
<!ENTITY % term         "term"                                       >
<!ENTITY % title        "title"                                      >
<!ENTITY % tm           "tm"                                         >
<!ENTITY % ul           "ul"                                         >
<!ENTITY % unknown      "unknown"                                    >
<!ENTITY % xref         "xref"                                       >

<!--                    Redeclare the reusable modules needed for 
                        the paragraph                              -->
<!ENTITY % basic.block 
  "%dl; | 
   %fig; | 
   %image; | 
   %lines; | 
   %lq; | 
   %note; | 
   %object; | 
   %ol;| 
   %p; | 
   %pre; | 
   %simpletable; | 
   %sl; | 
   %table; | 
   %ul;
  "
>
<!ENTITY % basic.ph 
  "%boolean; | 
   %cite; | 
   %keyword; | 
   %ph; | 
   %q; |
   %term; | 
   %tm; | 
   %xref; | 
   %state;
  "
>
<!ENTITY % data.elements.incl 
  "%data; |
   %data-about;
  "
>
<!ENTITY % foreign.unknown.incl 
  "%foreign; | 
   %unknown;
  " 
>
<!ENTITY % txt.incl 
  "%draft-comment; |
   %fn; |
   %indextermref; |
   %indexterm; |
   %required-cleanup;
  ">

<!--                    Declare the strict section 
                        content module                             -->
<!ENTITY % section.cnt.strict 
  "%basic.block; | 
   %basic.ph; | 
   %data.elements.incl; | 
   %foreign.unknown.incl; |
   %sectiondiv; | 
   %title; | 
   %txt.incl;
  "
>

<!--                    Override the section content module        -->
<!ENTITY % section.content
                        "(%section.cnt.strict;)*">

<!-- ================== End Strict Taskbody Entities ============= -->
