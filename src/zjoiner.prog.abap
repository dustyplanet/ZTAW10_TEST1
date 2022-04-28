*                             ''~``
*                            ( o o )
*    +------------------.oooO--(_)--Oooo.------------------+
*    |  ZJOINER - Generates join-based SELECT statements   |
*    |        so you can spend more time on SDN ;-)        |
*    |    Concept and code:         Dushyant Shetty        |
*    |                    .oooO                            |
*    |                    (   )   Oooo.           20070711 |
*    +---------------------\ ( ---(   )--------------------+
*                           \_)    ) /
*                                 (_/
REPORT  zjoiner NO STANDARD PAGE HEADING LINE-SIZE 130.

TYPE-POOLS: icon.

DATA: flagpop,
      title   LIKE sy-title VALUE 'Select the tables you wish to join',
      BEGIN OF watab,
        tno     TYPE i,
        parent  TYPE i,
        tabname TYPE dd02l-tabname,
      END OF watab,
      jtables       LIKE TABLE OF watab,
      cur_field(25),
      b_sel(18)     VALUE 'Select base table',
      b_rel(14)     VALUE 'Related Tables',
      b_del(12)     VALUE 'Delete Table',
      b_dis(18)     VALUE 'Display Conditions',
      b_fld(16)     VALUE 'Select Fields',
      b_exe(30)     VALUE 'Generate SELECT statement!',
      b_cop(30)     VALUE 'Copy Query to Clipboard...',
      b_hel(36)     VALUE 'Click here for detailed instructions',

      BEGIN OF wa_joins,
        ltab   TYPE dd02l-tabname,
        rtab   TYPE dd02l-tabname,
        jtype,
        field1 TYPE dd03l-fieldname,
        field2 TYPE dd03l-fieldname,
      END OF wa_joins,
      it_joins LIKE TABLE OF wa_joins,

      BEGIN OF wa_av_fields,
        tabname   TYPE dd02l-tabname,
        fieldname TYPE dd03l-fieldname,
        alias     TYPE dd03l-fieldname,
        text      TYPE dd04t-scrtext_l,
        selected,
        pos       TYPE i,
      END OF wa_av_fields,

      it_av_fields LIKE TABLE OF wa_av_fields,
      t_done(75)   VALUE 'Click the cancel button    (F12) when done..',
      flagsel,
      qtext(72),
      qtab         LIKE TABLE OF qtext,
      not_all.

*Declarations for relationships
TYPES: BEGIN OF ddtab_tabdef,
         dd02v LIKE dd02v,
         dd03p LIKE dd03p OCCURS 0,
         dd05m LIKE dd05m OCCURS 0,
         dd08v LIKE dd08v OCCURS 0,
       END OF ddtab_tabdef,
       ddtab_set TYPE ddtab_tabdef OCCURS 10.

DATA BEGIN OF ddtb.
INCLUDE STRUCTURE dd27p.
DATA: mark(1),
      mod(1).
DATA END OF ddtb.

DATA: ddtb_tab LIKE ddtb OCCURS 50 WITH HEADER LINE.
DATA: base_tabs TYPE ddtab_set.

DATA BEGIN OF itab1.
INCLUDE STRUCTURE dd26v.
DATA: mark(1).
DATA END OF itab1.

DATA: tc1_tab LIKE itab1 OCCURS 10 WITH HEADER LINE.

DATA BEGIN OF itab2.
INCLUDE STRUCTURE dd28j.
DATA: mark(1).
DATA END OF itab2.

DATA: tc2_tab LIKE itab2 OCCURS 10 WITH HEADER LINE.

DATA BEGIN OF itab3.
INCLUDE STRUCTURE dd28v.
DATA: mark(1).
DATA END OF itab3.

DATA: tc3_tab LIKE itab3 OCCURS 10 WITH HEADER LINE.

DATA: i TYPE i.
DATA subrc LIKE sy-subrc.
DATA: ddxx LIKE dd25v.

*---------------------------------------------------------------------*
*       CLASS lcl_type DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_type DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS get_type IMPORTING name      TYPE string
                           RETURNING VALUE(ty) TYPE string.
ENDCLASS.                    "lcl_type DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_type IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_type IMPLEMENTATION.
  METHOD get_type.
    DATA: des TYPE REF TO cl_abap_elemdescr,
          df  TYPE dfies.
    des ?= cl_abap_typedescr=>describe_by_name( name ).
    df = des->get_ddic_field( ).
    ty = df-datatype.
  ENDMETHOD.                    "get_type
ENDCLASS.                    "lcl_type IMPLEMENTATION


START-OF-SELECTION.
  SET BLANK LINES ON.
  sy-title = title.
  watab-tno = 1.
  APPEND watab TO jtables.
  PERFORM list_tabs.

AT LINE-SELECTION.
  CASE sy-lsind.
    WHEN 1.
      GET CURSOR FIELD cur_field.
      CASE cur_field.
        WHEN 'ICON_SEARCH' OR 'B_SEL'.
          PERFORM value_help.
          PERFORM list_tabs.
          sy-lsind = 0.
        WHEN 'ICON_REFERENCE_LIST' OR 'B_REL'.
          CLEAR: ddtb, ddtb_tab[], base_tabs[],
         itab1, tc1_tab[],
         itab2, tc2_tab[],
         itab3, tc3_tab[],
                          i, subrc, ddxx.
          tc1_tab-viewname = 'ZV_DUSTYPLANET'.
          tc1_tab-tabname = watab-tabname.
          tc1_tab-fortabname = watab-tabname.
          tc1_tab-mark = 'X'.
          APPEND tc1_tab.
          PERFORM v_list_joins.
          CLEAR qtab[].
          PERFORM list_tabs.
          sy-lsind = 0.
        WHEN 'ICON_DISPLAY' OR 'B_DIS'.
          CHECK watab-tno NE 1.
          PERFORM show_relationship.
        WHEN 'ICON_DELETE' OR 'B_DEL'.
          PERFORM confirm_delete.
          CLEAR qtab[].
          PERFORM del_table_and_joins USING watab-tno.
          PERFORM reorg_tables.
          PERFORM list_tabs.
          sy-lsind = 0.
        WHEN 'ICON_TERMINOLOGY' OR 'B_FLD'.
          CLEAR qtab[].
          WINDOW STARTING AT 10 10 ENDING AT 120 25.
          PERFORM select_fields.
        WHEN 'ICON_EXECUTE_OBJECT' OR 'B_EXE'.
          PERFORM check_fields.
          PERFORM gen_query.
          PERFORM list_tabs.
          sy-lsind = 0.
        WHEN 'ICON_SYSTEM_COPY' OR 'B_COP'.
          PERFORM copy_to_clipboard.
        WHEN 'ICON_SYSTEM_HELP' OR 'B_HEL'.
          PERFORM load_help.
      ENDCASE.
    WHEN 2.
      GET CURSOR FIELD cur_field.
      CASE cur_field.
        WHEN 'ICON_INSERT_ROW'.
          READ TABLE it_av_fields INTO wa_av_fields
               WITH KEY tabname = wa_av_fields-tabname
                      fieldname = wa_av_fields-fieldname.
          PERFORM check_alias USING wa_av_fields.
          wa_av_fields-selected = 'X'.
          MODIFY it_av_fields
          FROM wa_av_fields
         TRANSPORTING selected alias
               WHERE tabname = wa_av_fields-tabname
                         AND fieldname = wa_av_fields-fieldname.
          PERFORM select_fields.
          SCROLL LIST INDEX sy-lsind TO PAGE 1 LINE sy-staro.
          sy-lsind = 1.
        WHEN 'ICON_DELETE_ROW'.
          READ TABLE it_av_fields INTO wa_av_fields
                  WITH KEY tabname = wa_av_fields-tabname
                              fieldname = wa_av_fields-fieldname.
          CLEAR: wa_av_fields-selected,
     wa_av_fields-alias.
          MODIFY it_av_fields FROM wa_av_fields INDEX sy-tabix.
          PERFORM select_fields.
          SCROLL LIST INDEX sy-lsind TO PAGE 1 LINE sy-staro.
          sy-lsind = 1.
        WHEN 'ICON_WORKFLOW_ACTIVITY'.
          PERFORM add_all_fields USING wa_av_fields-tabname.
          PERFORM select_fields.
          SCROLL LIST INDEX sy-lsind TO PAGE 1 LINE sy-staro.
          sy-lsind = 1.
      ENDCASE.
  ENDCASE.

TOP-OF-PAGE.
  FORMAT COLOR COL_HEADING INTENSIFIED.
  ULINE.
  WRITE: sy-vline,
  'Select the tables you wish to join',
  ' by clicking on the appropriate icons...',
  icon_system_help AS ICON HOTSPOT,
  b_hel COLOR COL_TOTAL INTENSIFIED HOTSPOT,
  icon_system_help AS ICON HOTSPOT,
  AT sy-linsz sy-vline.
  ULINE.

TOP-OF-PAGE DURING LINE-SELECTION.
  IF flagpop IS INITIAL AND flagsel EQ 'X'.
    ULINE.
    WRITE: sy-vline,
    'Select the fields you wish to use from the list below',
    AT sy-linsz sy-vline.
    WRITE: sy-vline,
    (53) t_done  COLOR COL_TOTAL CENTERED,
    AT 31 icon_cancel COLOR COL_TOTAL AS ICON,
    AT sy-linsz sy-vline.
  ELSEIF cur_field EQ 'B_DIS' OR cur_field EQ 'ICON_DISPLAY'.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    ULINE.
    WRITE: sy-vline,
                  'Join conditions',
                  AT sy-linsz sy-vline.
    ULINE.
    CLEAR cur_field.
  ELSE.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    ULINE.
    WRITE: sy-vline,
    'Select the tables you wish to join',
    ' by clicking on the appropriate icons...',
    icon_system_help AS ICON HOTSPOT,
    b_hel COLOR COL_TOTAL INTENSIFIED HOTSPOT,
    icon_system_help AS ICON HOTSPOT,
    AT sy-linsz sy-vline.
    ULINE.
  ENDIF.

*&--------------------------------------------------------------------*
*&      Form  value_help
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM value_help.
  DATA: old_tab   TYPE dd02l-tabname,
        result    VALUE '1',
        text(150).
  old_tab = watab-tabname.
  IF lines( jtables ) > 1.
    CONCATENATE 'All tables and joins will be deleted...'
    'Are you sure you want to select a new base table?'
    INTO text SEPARATED BY space.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = 'Warning...'
        text_question         = text
        display_cancel_button = space
      IMPORTING
        answer                = result.
  ENDIF.
  IF result = '1'.
    CALL FUNCTION 'F4_DD_TABLES'
      EXPORTING
        object             = watab-tabname
        suppress_selection = 'X'
      IMPORTING
        result             = watab-tabname.
    IF watab-tabname NE old_tab.
      CLEAR: jtables[], it_joins[], it_av_fields[].
      watab-tno = 1.
      APPEND watab TO jtables.
      PERFORM get_fields USING watab-tabname.
    ELSE.
      MESSAGE 'Base table not changed...' TYPE 'S'.
    ENDIF.
  ENDIF.
ENDFORM.                    "value_help

*&--------------------------------------------------------------------*
*&      Form  list_tabs
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM list_tabs.
  LOOP AT jtables INTO watab.
    NEW-LINE.
    WRITE: sy-vline,
    (2) watab-tno,
    sy-vline,
    watab-tabname COLOR COL_NORMAL,
    sy-vline,
    60 sy-vline,
    icon_reference_list AS ICON HOTSPOT,
    b_rel COLOR COL_TOTAL INTENSIFIED HOTSPOT,
    sy-vline,
    icon_display AS ICON HOTSPOT,
    b_dis COLOR COL_GROUP INTENSIFIED HOTSPOT,
    sy-vline,
icon_delete AS ICON HOTSPOT,
          b_del COLOR COL_NEGATIVE HOTSPOT,
          AT sy-linsz sy-vline.
    IF sy-tabix = 1.
      WRITE: 40   b_sel COLOR COL_KEY HOTSPOT.
      WRITE: 58   icon_search AS ICON HOTSPOT.
      WRITE: 82(22) space.
      IF watab-tabname IS INITIAL.
        WRITE: 61(19) space.
        WRITE: 105(20) space.
      ENDIF.
    ENDIF.
    HIDE: watab-tabname, watab-tno, watab-parent.
    CLEAR watab.
  ENDLOOP.
  ULINE.
  READ TABLE jtables INTO watab INDEX 1.
  IF watab-tabname IS NOT INITIAL.
    WRITE:sy-vline,
    icon_terminology AS ICON HOTSPOT,
    b_fld COLOR COL_KEY INTENSIFIED HOTSPOT,
    AT sy-linsz sy-vline.
    ULINE.
    WRITE:sy-vline,
    icon_execute_object AS ICON HOTSPOT,
b_exe COLOR COL_KEY INTENSIFIED HOTSPOT,
     AT sy-linsz sy-vline.
    ULINE.
    IF qtab IS NOT INITIAL.
      FORMAT COLOR COL_TOTAL INTENSIFIED.
      ULINE.
      WRITE:sy-vline,
      (128) 'SELECT statement generated successfully!' CENTERED,
      AT sy-linsz sy-vline.
      ULINE.
      WRITE:sy-vline,
      50 icon_system_copy AS ICON HOTSPOT,
      b_cop HOTSPOT,
      AT sy-linsz sy-vline.
      ULINE.
      FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
      LOOP AT qtab INTO qtext.
        WRITE:sy-vline,
                       qtext,
                       AT sy-linsz sy-vline.
      ENDLOOP.
      ULINE.
      FORMAT RESET.
    ENDIF.
  ENDIF.
  CLEAR watab.
ENDFORM.                    "list_tabs

*&--------------------------------------------------------------------*
*&      Form  v_list_joins
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM v_list_joins.
  DATA: dd05m_out    LIKE dd05m OCCURS 20 WITH HEADER LINE,
        dd08v_out    LIKE dd08v OCCURS 10 WITH HEADER LINE,
        dd08v_ok     LIKE dd08v OCCURS 10,
        dd08v_no     LIKE dd08v OCCURS 10,
        dd08v_tab    LIKE dd08v OCCURS 10 WITH HEADER LINE,
        basetabnames LIKE dd26v OCCURS 10 WITH HEADER LINE.
  DATA:    BEGIN OF tab_joins OCCURS 10.
      INCLUDE STRUCTURE dd05m.
  DATA:        mark(1),
  sele(1),
  nofs(1),
  END OF tab_joins.
  PERFORM get_basetab_info(radvimnt)
  TABLES tc1_tab
             base_tabs
             USING
             0
             ddxx
             CHANGING
             subrc.

  CLEAR basetabnames[].
  LOOP AT tc1_tab INTO basetabnames
  WHERE mark = 'X'.
    APPEND basetabnames.
  ENDLOOP.
  ddxx-viewclass = 'D'.
  PERFORM get_all_frks(radvimnt)
  TABLES base_tabs
   basetabnames
   dd08v_out
   dd05m_out
   USING
   ddxx
   space.
  DESCRIBE TABLE dd08v_out LINES i.
  IF i = 0.
    READ TABLE basetabnames INDEX 1
   TRANSPORTING tabname.
    IF sy-tfill = 1.
      MESSAGE s315(e2) WITH basetabnames-tabname.
    ELSE.
      MESSAGE s306(e2).
    ENDIF.
  ELSE.
    dd08v_ok[] = dd08v_out[].
    CLEAR dd08v_no[].
    PERFORM v_list_fk_head
    TABLES basetabnames
    dd08v_ok
dd08v_no
           dd05m_out.
  ENDIF.
ENDFORM.                    "v_list_joins

*&--------------------------------------------------------------------*
*&      Form  v_list_fk_head
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->BASETABNAMEtext
*      -->DD08V_OK   text
*      -->DD08V_NO   text
*      -->DD05M_OUT  text
*---------------------------------------------------------------------*
FORM v_list_fk_head
TABLES basetabnames
STRUCTURE
dd26v
 dd08v_ok
 dd08v_no
 dd05m_out.
  DATA: tabnams   LIKE dd02l-tabname OCCURS 10 WITH HEADER LINE,
        dd08v_tab LIKE dd08v OCCURS 10 WITH HEADER LINE.
  DATA: BEGIN OF tab_joins OCCURS 10.
      INCLUDE STRUCTURE dd08v.
  DATA: mark(1),
        sele(1),
        END OF tab_joins,
        ltab       TYPE dd02l-tabname,
        old_tno    TYPE i,
        wa_check   LIKE watab,
        dup_tables LIKE RANGE OF watab-tabname,
        wa_dup     LIKE LINE OF dup_tables.
  LOOP AT basetabnames.
    tabnams = basetabnames-tabname.
    APPEND tabnams.
  ENDLOOP.
  tab_joins[] = dd08v_ok[].
  CALL FUNCTION 'DD_LIST_TAB_RELATIONS'
    EXPORTING
      viewclass    = ddxx-viewclass
    TABLES
      tab_names    = tabnams
      dd08v_ok     = tab_joins
      dd08v_no     = dd08v_no
      dd05m_tab    = dd05m_out
    EXCEPTIONS
      not_executed = 1
      OTHERS       = 2.
  IF sy-subrc = 0.
    CLEAR: dd08v_tab[].
    LOOP AT tab_joins
    WHERE mark = 'X'
    AND sele   = ' '.
      dd08v_tab = tab_joins.
      APPEND dd08v_tab.
    ENDLOOP.
    IF sy-subrc = 0.
      PERFORM add_join_from_frk(radvimnt)
      TABLES base_tabs
     tc1_tab                                  "dd26v_tab
                       tc2_tab                                   "dd28j_tab
                       tc3_tab                                   "dd28v_rest
                       dd08v_tab "dd08v_tab
                       USING ddxx
                       CHANGING subrc.
      IF subrc = 4.
        MESSAGE s325(e2).
      ELSE.
        ltab = watab-tabname.
        old_tno = watab-tno.
        LOOP AT tc1_tab.
          IF sy-tabix NE 1.
            READ TABLE jtables INTO wa_check
            WITH KEY tabname = tc1_tab-tabname TRANSPORTING tabname.
            IF sy-subrc NE 0.
              watab-parent = old_tno.
              ADD 1 TO watab-tno.
              watab-tabname = tc1_tab-tabname.
              APPEND watab TO jtables.
              PERFORM get_fields USING watab-tabname.
            ELSEIF sy-subrc = 0.
              wa_dup-sign = 'I'.
              wa_dup-option = 'EQ'.
              wa_dup-low = wa_check-tabname.
              APPEND wa_dup TO dup_tables.
            ENDIF.
          ENDIF.
        ENDLOOP.
        LOOP AT tc2_tab.
          CHECK dup_tables IS INITIAL
          OR  ( tc2_tab-ltab NOT IN dup_tables
              AND
              tc2_tab-ltab NOT IN dup_tables ).
          wa_joins-ltab = tc2_tab-ltab.
          wa_joins-rtab = tc2_tab-rtab.
          wa_joins-field1 = tc2_tab-lfield.
          wa_joins-field2 = tc2_tab-rfield.
          APPEND wa_joins TO it_joins.
        ENDLOOP.
        PERFORM reorg_tables.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "v_list_fk_h

*&--------------------------------------------------------------------*
*&      Form  tab_dupl
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM tab_dupl.
  DATA: checktab LIKE jtables,
        wa_check LIKE LINE OF checktab,
        wa_old   LIKE wa_check,
        text(50).
  checktab = jtables.
  SORT checktab BY tabname.
  LOOP AT checktab INTO wa_check.
    IF wa_check-tabname IS NOT INITIAL
    AND wa_check-tabname = wa_old-tabname.
      CONCATENATE 'Table '
      wa_old-tabname
      ' has already been added'
      INTO text SEPARATED BY space.
      MESSAGE text TYPE 'E'.
    ENDIF.
    wa_old = wa_check.
  ENDLOOP.
ENDFORM.                    "tab_dupl

*&--------------------------------------------------------------------*
*&      Form  show_relationship
*&--------------------------------------------------------------------
*
*       text
*---------------------------------------------------------------------*
FORM show_relationship.
  DATA: text(73),
  wapre LIKE watab.
  flagpop = 'X'.
  FORMAT COLOR COL_GROUP INTENSIFIED.
  NEW-PAGE.
  READ TABLE jtables INTO wapre
WITH KEY tno = watab-parent.
  WINDOW STARTING AT 10 10 ENDING AT 100 15.
  LOOP AT it_joins INTO wa_joins
  WHERE
  ( rtab = watab-tabname AND ltab = wapre-tabname )
  OR
  ( ltab = watab-tabname AND rtab = wapre-tabname ).
    ULINE (75).
    CONCATENATE wa_joins-ltab '-'
    wa_joins-field1
    ` = `
    wa_joins-rtab '-'
    wa_joins-field1 INTO text.
    CONDENSE text.
    WRITE:/ sy-vline,
    text,
    AT 75 sy-vline.
  ENDLOOP.
  ULINE (75).
  CLEAR flagpop.
ENDFORM.                    "show_relationship

*&--------------------------------------------------------------------*
*&      Form  del_table_and_joins
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->P_TNO      text
*---------------------------------------------------------------------*
FORM del_table_and_joins USING p_tno TYPE i.
  DATA: wapre   LIKE watab,
        wacurr  LIKE watab,
        wachild LIKE watab.
  READ TABLE jtables INTO wacurr WITH KEY tno = p_tno.
  READ TABLE jtables INTO wapre WITH KEY tno = wacurr-parent.
  LOOP AT it_joins INTO wa_joins
  WHERE
  ( rtab = wacurr-tabname AND ltab = wapre-tabname )
  OR
  ( ltab = wacurr-tabname AND rtab = wapre-tabname ).
    DELETE TABLE it_joins FROM wa_joins.
  ENDLOOP.
  LOOP AT jtables INTO wachild WHERE parent = wacurr-tno.
    PERFORM del_table_and_joins USING wachild-tno.
  ENDLOOP.
  DELETE it_av_fields WHERE tabname = wacurr-tabname.
  DELETE TABLE jtables FROM wacurr.
ENDFORM.                    "del_table_and_joins

*&--------------------------------------------------------------------*
*&      Form reorg_tables
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM reorg_tables.
  DATA: wa_curr LIKE LINE OF jtables.
  IF jtables IS INITIAL.
    wa_curr-tno = 1.
    APPEND wa_curr TO jtables.
  ELSE.
    LOOP AT jtables INTO wa_curr.
      wa_curr-tno = sy-tabix.
      MODIFY TABLE jtables FROM wa_curr.
    ENDLOOP.
  ENDIF.
ENDFORM.                    "reorg_tables

*&--------------------------------------------------------------------*
*&      Form  confirm_delete
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM confirm_delete.
  DATA: text(150),
  result, wa_curr LIKE LINE OF jtables.
  READ TABLE jtables INTO wa_curr INDEX 1.
  IF wa_curr-tabname IS INITIAL.
    MESSAGE 'Nothing to delete...' TYPE 'E'.
  ELSE.
    CONCATENATE 'Do you wish to delete the table' watab-tabname
 ', its dependent tables and their join conditions?'
           INTO text SEPARATED BY space.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = 'Warning...'
        text_question         = text
        display_cancel_button = space
      IMPORTING
        answer                = result.
    IF result = '2'.
      MESSAGE 'Delete action cancelled by user...' TYPE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.                    "confirm_delete

*&--------------------------------------------------------------------*
*&      Form  get_fields
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->PTABNAME text
*---------------------------------------------------------------------*
FORM get_fields USING ptabname TYPE dd02l-tabname.
  DATA: BEGIN OF wa_field,
          pos       TYPE dd03l-position,
          fieldname TYPE dd03l-fieldname,
          text      TYPE dd04t-scrtext_l,
        END OF wa_field,
        it_fields LIKE TABLE OF wa_field.
  SELECT dd03l~position dd03l~fieldname dd04t~scrtext_l
  INTO TABLE it_fields
  FROM dd03l INNER JOIN dd04t
  ON dd03l~rollname = dd04t~rollname
WHERE dd03l~tabname = ptabname
      AND dd04t~ddlanguage = sy-langu
  AND dd03l~datatype NE 'CLNT'
  ORDER BY dd03l~position.
  wa_av_fields-tabname = ptabname.
  LOOP AT it_fields INTO wa_field.
    MOVE-CORRESPONDING wa_field TO wa_av_fields.
    APPEND wa_av_fields TO it_av_fields.
  ENDLOOP.
ENDFORM.                    "get_fields

*&--------------------------------------------------------------------*
*&      Form  SELECT_FIELDS
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM select_fields.
  flagsel = 'X'.
  ULINE.
  WRITE: sy-vline,
  (30) 'Available Fields' CENTERED,
          (2) space,
          sy-vline,
  (25) 'Description' CENTERED,
          sy-vline,
          (2) space,
          (30) 'Selected Fields' CENTERED,
          sy-vline,
          (14) 'Alias' CENTERED,
          AT sy-linsz sy-vline.
  FORMAT COLOR COL_TOTAL.
  LOOP AT it_av_fields INTO wa_av_fields.
    AT NEW tabname.
      FORMAT COLOR COL_GROUP INTENSIFIED.
      ULINE.
      WRITE: sy-vline,
      (60) wa_av_fields-tabname,
      34 icon_workflow_activity AS ICON HOTSPOT QUICKINFO 'Select All',
      AT sy-linsz sy-vline.
      HIDE wa_av_fields-tabname.
      ULINE.
      FORMAT COLOR COL_TOTAL.
    ENDAT.
    IF wa_av_fields-selected IS INITIAL.
      WRITE: sy-vline,
      (30) wa_av_fields-fieldname,
      icon_insert_row AS ICON HOTSPOT,
     sy-vline,
                 (25) wa_av_fields-text,
                 sy-vline,
                 (2) space,
                 (30) space COLOR COL_KEY,
                 sy-vline,
                 (14) wa_av_fields-alias ,
                 AT sy-linsz sy-vline.
    ELSEIF wa_av_fields-alias IS INITIAL.
      WRITE: sy-vline,
      (30) space,
      (2) space,
      sy-vline,
      (25) wa_av_fields-text,
      sy-vline,
      icon_delete_row AS ICON HOTSPOT,
      (30) wa_av_fields-fieldname COLOR COL_KEY,
      sy-vline,
      (14) space,
      AT sy-linsz sy-vline.
    ELSE.
      WRITE: sy-vline,
      (30) space,
      (2) space,
      sy-vline,
      (25) wa_av_fields-text,
sy-vline,
icon_delete_row AS ICON HOTSPOT,
(30) wa_av_fields-fieldname COLOR COL_TOTAL INTENSIFIED,
sy-vline,
(14) wa_av_fields-alias COLOR COL_KEY,
AT sy-linsz sy-vline.
    ENDIF.
    HIDE:
wa_av_fields-tabname,
         wa_av_fields-fieldname.
  ENDLOOP.
  ULINE.
  CLEAR: flagsel, wa_av_fields.
ENDFORM.                    "SELECT_FIELDS

*&--------------------------------------------------------------------*
*&      Form  CHECK_ALIAS
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->P_WA       text
*---------------------------------------------------------------------*
FORM check_alias CHANGING p_wa LIKE wa_av_fields.
  DATA: wa_check  LIKE p_wa,
        text1(50),
        text2(50),
        text3(30),
        result,
        subrc     LIKE sy-subrc.
  READ TABLE it_av_fields INTO wa_check
  WITH KEY fieldname = p_wa-fieldname
 alias = space
  selected = 'X'.
  IF sy-subrc = 0.
    CONCATENATE wa_check-tabname '-' p_wa-fieldname
    INTO text1.
    text2 = 'already exists. Please enter an'.
    text3 = 'alias for this field...'.
    CALL FUNCTION 'POPUP_TO_GET_ONE_VALUE'
      EXPORTING
        textline1   = text1
        textline2   = text2
        textline3   = text3
        titel       = 'Alias needed !'
        valuelength = 14
      IMPORTING
        answer      = result
        value1      = p_wa-alias.
    IF result = 'A'.
      MESSAGE 'Alias must be specified...' TYPE 'E' DISPLAY LIKE 'I'.
    ELSE.
      READ TABLE it_av_fields INTO wa_check
      WITH KEY alias = p_wa-alias
      selected = 'X'.
      READ TABLE it_av_fields INTO wa_check
      WITH KEY fieldname = p_wa-alias
      selected = 'X'.
      IF sy-subrc EQ 0 OR subrc EQ 0.
        DO.
          CLEAR p_wa-alias.
          CALL FUNCTION 'POPUP_TO_GET_ONE_VALUE'
            EXPORTING
              textline1   = 'The alias you specified'
              textline2   = 'already exists!'
              textline3   = 'Please enter a new alias...'
              titel       = 'Alias needed !'
              valuelength = 14
            IMPORTING
              answer      = result
              value1      = p_wa-alias.
          IF result = 'A'.
            MESSAGE 'Alias must be specified...' TYPE 'E' DISPLAY LIKE 'I'.
          ELSE.
            READ TABLE it_av_fields INTO wa_check
WITH KEY alias = p_wa-alias
                     selected = 'X'.
            IF sy-subrc NE 0.
              READ TABLE it_av_fields INTO wa_check
              WITH KEY fieldname = p_wa-alias
              selected = 'X'.
              IF sy-subrc NE 0.
                EXIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDDO.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "CHECK_A

*&--------------------------------------------------------------------*
*&      Form  gen_query
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM gen_query.
  DATA:fname TYPE string,
       it_av LIKE it_av_fields.
  CLEAR qtab[].
  it_av = it_av_fields.
  DELETE it_av WHERE selected = space.
  IF lines( jtables ) EQ 1 AND it_joins IS INITIAL.
    APPEND 'SELECT' TO qtab.
    LOOP AT it_av INTO wa_av_fields.
      AT NEW tabname.
        CONCATENATE '****Fields from'
       wa_av_fields-tabname
                         INTO qtext SEPARATED BY space.
        APPEND qtext TO qtab.
      ENDAT.
      CONCATENATE `        ` wa_av_fields-fieldname INTO qtext.
      APPEND qtext TO qtab.
    ENDLOOP.
    APPEND '****Target' TO qtab.
    APPEND 'INTO [target] "replace with data object(s)'
          TO qtab.
    CONCATENATE 'FROM' wa_av_fields-tabname
    INTO qtext SEPARATED BY space.
    APPEND qtext TO qtab.
  ELSE.
    APPEND 'SELECT' TO qtab.
    LOOP AT it_av INTO wa_av_fields.
      AT NEW tabname.
        CONCATENATE '****Fields from'
        wa_av_fields-tabname
        INTO qtext SEPARATED BY space.
        APPEND qtext TO qtab.
      ENDAT.
      CONCATENATE `        ` wa_av_fields-tabname '~'
    wa_av_fields-fieldname
    INTO qtext.
      IF wa_av_fields-alias IS NOT INITIAL.
        CONCATENATE qtext 'AS' wa_av_fields-alias
        INTO qtext SEPARATED BY space.
      ENDIF.
      APPEND qtext TO qtab.
    ENDLOOP.
    APPEND '****Target' TO qtab.
    APPEND 'INTO [target] "replace with data object(s)'
    TO qtab.
    APPEND '****Inner joins' TO qtab.
    APPEND 'FROM' TO qtab.
    LOOP AT it_joins INTO wa_joins.
      AT NEW ltab.
        IF sy-tabix = 1.
          APPEND wa_joins-ltab TO qtab.
        ENDIF.
      ENDAT.
      AT NEW rtab.
        CONCATENATE 'INNER JOIN' wa_joins-rtab 'ON'
        INTO qtext SEPARATED BY space.
        APPEND qtext TO qtab.
      ENDAT.
      IF qtext(5) NE 'INNER'.
        CONCATENATE `          ` 'AND' INTO qtext.
        APPEND qtext TO qtab.
      ELSE.
        CONCATENATE wa_joins-rtab '-' wa_joins-field2 INTO fname.
        IF lcl_type=>get_type( fname ) = 'CLNT'.
          CONTINUE.
        ENDIF.
      ENDIF.
      CONCATENATE `          ` wa_joins-ltab '~' wa_joins-field1 ` = `
      wa_joins-rtab '~' wa_joins-field2
      INTO qtext.
      APPEND qtext TO qtab.
    ENDLOOP.
  ENDIF.
ENDFORM. "gen_query

*&--------------------------------------------------------------------*
*&      Form  check_fields
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM check_fields.
  READ TABLE it_av_fields INTO wa_av_fields
                       WITH KEY selected = 'X'
                       TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    MESSAGE 'Select at least one field...'
    TYPE 'E' DISPLAY LIKE 'I'.
  ENDIF.
ENDFORM.                    "check_fields

*&--------------------------------------------------------------------*
*&      Form  add_all_fields
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->TNAME      text
*---------------------------------------------------------------------*
FORM add_all_fields USING tname LIKE wa_av_fields-tabname.
  DATA wa_fields LIKE wa_av_fields.
  DATA: wa_check  LIKE wa_fields,
        text1(50), text2(50), text3(30), result, subrc LIKE sy-subrc.
  LOOP AT it_av_fields INTO wa_fields WHERE tabname = tname
                                       AND selected IS INITIAL.
    READ TABLE it_av_fields INTO wa_check
     WITH KEY fieldname = wa_fields-fieldname
     alias = space
     selected = 'X'.
    IF sy-subrc = 0.
      CONCATENATE wa_fields-fieldname 'already exists.'
      INTO text1 SEPARATED BY space.
      text2 = 'Enter an alias. It can consist of'.
      text3 = 'only alphabets and digits...'.
      CALL FUNCTION 'POPUP_TO_GET_ONE_VALUE'
        EXPORTING
          textline1   = text1
          textline2   = text2
          textline3   = text3
          titel       = 'Alias needed !'
          valuelength = 14
        IMPORTING
          answer      = result
          value1      = wa_fields-alias.
      IF result = 'A'.
        MESSAGE 'Alias must be specified...' TYPE 'I'.
        CONTINUE.
      ELSE.
        READ TABLE it_av_fields INTO wa_check
        WITH KEY alias = wa_fields-alias
        selected = 'X'.
        subrc = sy-subrc.
        READ TABLE it_av_fields INTO wa_check
        WITH KEY fieldname = wa_fields-alias
        selected = 'X'.
        IF sy-subrc EQ 0 OR subrc EQ 0.
          DO.
            CLEAR wa_fields-alias.
            CALL FUNCTION 'POPUP_TO_GET_ONE_VALUE'
              EXPORTING
                textline1   = 'The alias you specified'
                textline2   = 'already exists!'
                textline3   = 'Please enter a new alias...'
                titel       = 'Alias needed !'
                valuelength = 14
              IMPORTING
                answer      = result
                value1      = wa_fields-alias.
            IF result = 'A'.
              CALL FUNCTION 'POPUP_TO_CONFIRM'
                EXPORTING
                  titlebar      = 'Cancel Action?'
                  text_question = 'Stop adding fields?'
                  text_button_1 = 'Yes'
                  text_button_2 = 'No'
                IMPORTING
                  answer        = result.
              IF result = 1.
                EXIT.
              ELSE.
                CONTINUE.
              ENDIF.
            ELSE.
              READ TABLE it_av_fields INTO wa_check
              WITH KEY alias = wa_fields-alias
              selected = 'X'.
              IF sy-subrc NE 0.
                READ TABLE it_av_fields INTO wa_check
                WITH KEY fieldname = wa_fields-alias
                selected = 'X'.
                IF sy-subrc NE 0.
                  EXIT.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDDO.
          IF result = '1'.
            CLEAR result.
            EXIT.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    wa_fields-selected = 'X'.
    MODIFY it_av_fields
    FROM wa_fields
    TRANSPORTING selected alias
    WHERE tabname = wa_fields-tabname
    AND fieldname = wa_fields-fieldname.
  ENDLOOP.
ENDFORM.                    "add_all_fi

*&--------------------------------------------------------------------*
*&      Form copy_to_clipboard
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM copy_to_clipboard.
  DATA: rc TYPE i.
  CALL METHOD cl_gui_frontend_services=>clipboard_export
    IMPORTING
      data = qtab
    CHANGING
      rc   = rc.
  MESSAGE 'Query copied to clipboard!' TYPE 'I'.
ENDFORM.                    "copy_to_clipboard

FORM load_help.
  CALL FUNCTION 'WS_EXECUTE'
    EXPORTING
      program = '<a class="jive-link-external-small" href="/?p=44534">Tool for ABAP Developers: Easy ABAP Open SQL Joins!</a>'
    EXCEPTIONS
      OTHERS  = 0.
ENDFORM.

* _____     __  __     ______     ______   __  __
*/\  __-.  /\ \/\ \   /\  ___\   /\__  _\ /\ \_\ \
*\ \ \/\ \ \ \ \_\ \  \ \___  \  \/_/\ \/ \ \____ \
* \ \____-  \ \_____\  \/\_____\    \ \_\  \/\_____\
*  \/____/   \/_____/   \/_____/     \/_/   \/_____/
*
* ______   __         ______     __   __     ______     ______
*/\  == \ /\ \       /\  __ \   /\ "-.\ \   /\  ___\   /\__  _\
*\ \  _-/ \ \ \____  \ \  __ \  \ \ \-.  \  \ \  __\   \/_/\ \/
* \ \_\    \ \_____\  \ \_\ \_\  \ \_\\"\_\  \ \_____\    \ \_\
*  \/_/     \/_____/   \/_/\/_/   \/_/ \/_/   \/_____/     \/_/
