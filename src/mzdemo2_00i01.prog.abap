*----------------------------------------------------------------------*
***INCLUDE MZDEMO_00I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN 'TIME'.
      CALL SCREEN 150 STARTING AT 5 5 ENDING AT 70 15.
    WHEN 'TOG'.
      IF mod_flag = 'X'.
        mod_flag = space.
      ELSE.
        mod_flag = 'X'.
      ENDIF.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_SFLIGHT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_sflight INPUT.
  SELECT SINGLE * FROM sflight INTO wa_sflight WHERE carrid = sdyn_conn-carrid AND connid = sdyn_conn-connid
                                                 AND fldate = sdyn_conn-fldate.
  IF sy-subrc NE 0.
    MESSAGE 'No Flight found' TYPE 'E'.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_DATE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_date INPUT.
  IF sdyn_conn-fldate < sy-datum.
    MESSAGE 'Flight is in the past' TYPE 'W'.
  ENDIF.
ENDMODULE.
