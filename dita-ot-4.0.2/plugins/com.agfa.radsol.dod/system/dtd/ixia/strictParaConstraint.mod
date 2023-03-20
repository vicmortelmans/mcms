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
PUBLIC "-//IXIA//ELEMENTS IXIA DITA 1.2 Strict Paragraph Constraint//EN"
      Delivered as file "strictParaConstraint.mod"                 -->

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

<!ENTITY para-constraints     
                        "(topic strictPara-c)"                       >

<!--                    Redeclare the element entities needed for
                        the paragaph                               -->
<!ENTITY % boolean      "boolean"                                    >
<!ENTITY % cite         "cite"                                       >
<!ENTITY % data         "data"                                       >
<!ENTITY % data-about   "data-about"                                 >
<!ENTITY % draft-comment 
                        "draft-comment"                              >
<!ENTITY % fn           "fn"                                         >
<!ENTITY % foreign      "foreign"                                    >
<!ENTITY % image        "image"                                      >
<!ENTITY % indexterm    "indexterm"                                  >
<!ENTITY % indextermref "indextermref"                               >
<!ENTITY % keyword      "keyword"                                    >
<!ENTITY % ph           "ph"                                         >
<!ENTITY % q            "q"                                          >
<!ENTITY % required-cleanup     
                        "required-cleanup"                           >
<!ENTITY % state        "state"                                      >
<!ENTITY % term         "term"                                       >
<!ENTITY % tm           "tm"                                         >
<!ENTITY % unknown      "unknown"                                    >
<!ENTITY % xref         "xref"                                       >

<!--                    Redeclare the reusable modules needed for 
                        the paragraph                              -->
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

<!--                    Declare the strict paragraph 
                        content module                             -->
<!ENTITY % para.cnt.strict 
  "#PCDATA | 
   %image; | 
   %basic.ph; | 
   %data.elements.incl; | 
   %foreign.unknown.incl; | 
   %txt.incl;
  "
>

<!--                    Override the paragraph content module      -->
<!ENTITY % p.content    "(%para.cnt.strict;)*"                       >

<!-- ================== End Strict Taskbody Entities ============= -->
