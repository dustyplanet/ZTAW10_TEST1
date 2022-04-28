*----------------------------------------------------------------------*
***INCLUDE MZBC410_SOLUTION_00O01.
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
    IF r2 = 'X'.
      SET TITLEBAR 'TITLE_0100' WITH 'Change' wa_sflight-carrid wa_sflight-connid wa_sflight-fldate.
    ELSE.
      SET TITLEBAR 'TITLE_0100' WITH 'Display' wa_sflight-carrid wa_sflight-connid wa_sflight-fldate.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
  LOOP AT SCREEN.
    IF screen-name = 'SDYN_CONN-PLANETYPE'.
      IF r2 = 'X'.
        screen-input = 1.
      ELSE.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_CONN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_conn OUTPUT.
  SELECT SINGLE * FROM spfli INTO CORRESPONDING FIELDS OF sdyn_conn
    WHERE carrid = sdyn_conn-carrid AND connid = sdyn_conn-connid.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_PLANE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_plane OUTPUT.
  SELECT SINGLE * FROM saplane WHERE planetype = sdyn_conn-planetype.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SET_DYNNR  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_dynnr OUTPUT.
  CASE tab-activetab.
    WHEN 'T1'.
      dynnr = '0110'.
    WHEN 'T2'.
      dynnr = '0120'.
    WHEN 'T3'.
      dynnr = '0130'.
  ENDCASE.
ENDMODULE.
