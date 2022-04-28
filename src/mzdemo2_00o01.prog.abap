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
  IF wa_sflight-carrid IS NOT INITIAL.
    SELECT SINGLE * FROM spfli INTO wa_spfli WHERE carrid = wa_sflight-carrid AND connid = wa_sflight-connid.
    IF wa_spfli-countryfr = wa_spfli-countryto.
      CALL FUNCTION 'ICON_CREATE'
        EXPORTING
          name   = icon_incomplete
          text   = 'International Flight'
        IMPORTING
          result = icon1.
      "set domestic icon
    ELSE.
      CALL FUNCTION 'ICON_CREATE'
        EXPORTING
          name   = icon_checked
          text   = 'International Flight'
        IMPORTING
          result = icon1.
      "set international icon.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_CONN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_conn OUTPUT.
  SELECT SINGLE * FROM spfli WHERE carrid = sdyn_conn-carrid AND connid = sdyn_conn-connid.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_PLANE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_plane OUTPUT.
  SELECT SINGLE * FROM saplane WHERE planetype = sdyn_conn-planetype.
ENDMODULE.
