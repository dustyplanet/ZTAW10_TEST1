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
