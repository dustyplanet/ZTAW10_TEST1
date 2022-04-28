*----------------------------------------------------------------------*
***INCLUDE MZDEMO_00O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  MOVE_TO_DYNP  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE move_to_dynp OUTPUT.
  MOVE-CORRESPONDING wa_sflight TO sdyn_conn.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  IF wa_sflight-carrid IS INITIAL.
    SET TITLEBAR 'TITLE_0100'.
  ELSE.
    SELECT SINGLE carrname INTO carrname FROM scarr WHERE carrid = wa_sflight-carrid.
    IF mod_flag = 'X'.
      SET TITLEBAR 'TITLE_0100' WITH 'Change' carrname wa_sflight-connid wa_sflight-fldate.
    ELSE.
      SET TITLEBAR 'TITLE_0100' WITH 'Display' carrname wa_sflight-connid wa_sflight-fldate.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0150  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0150 OUTPUT.
  SET PF-STATUS 'STATUS_0150'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MOD_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE mod_screen OUTPUT.
  LOOP AT SCREEN. "no into
    IF screen-name = 'SDYN_CONN-PLANETYPE'.
      IF mod_flag = 'X'.
        screen-input = 1.
      ELSE.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SET_ICON  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_icon OUTPUT.
  if wa_sflight-carrid is not initial.
     select single * from spfli into wa_spfli where carrid = wa_sflight-carrid and connid = wa_sflight-connid.
     if wa_spfli-countryfr = wa_spfli-countryto.
       CALL FUNCTION 'ICON_CREATE'
         EXPORTING
          name                        = ICON_INCOMPLETE
          TEXT                        = 'International Flight'
        IMPORTING
          RESULT                      = icon1.
        "set domestic icon
     else.
        CALL FUNCTION 'ICON_CREATE'
         EXPORTING
          name                        = ICON_CHECKED
          TEXT                        = 'International Flight'
        IMPORTING
          RESULT                      = icon1.
        "set international icon.
     endif.
   endif.
ENDMODULE.
