*----------------------------------------------------------------------*
***INCLUDE MZBC410_SOLUTION_00I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  IF ok_code = 'BACK'.
    LEAVE PROGRAM.
  ELSEIF ok_code = 'TIME'.
    CALL SCREEN 150 STARTING AT 10 10 ENDING AT 70 20.
  ELSEIF ok_code = 'T1' OR ok_code = 'T2' OR ok_code = 'T3'.
    tab-activetab = ok_code.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_FLIGHT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_flight INPUT.
  SELECT SINGLE * FROM sflight INTO wa_sflight WHERE carrid = sdyn_conn-carrid AND connid = sdyn_conn-connid
                                                 AND fldate = sdyn_conn-fldate.
  IF sy-subrc NE 0.
    MESSAGE e007(bc410).
    CLEAR sdyn_conn.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      SET PARAMETER ID : 'CAR' FIELD wa_sflight-carrid,
                         'CON' FIELD wa_sflight-connid,
                         'DAY' FIELD wa_sflight-fldate.
      CLEAR: sdyn_conn, wa_sflight.
      LEAVE TO SCREEN 100.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_plane INPUT.
  IF sdyn_conn-planetype IS INITIAL.
    MESSAGE e555(bc410).
  ELSE.

    SELECT SINGLE seatsmax INTO sdyn_conn-seatsmax FROM saplane WHERE planetype = sdyn_conn-planetype.
    IF sdyn_conn-seatsmax <= sdyn_conn-seatsocc.
      MOVE-CORRESPONDING wa_sflight TO sdyn_conn.
      MESSAGE e109(bc410).
    ELSE.
      MOVE-CORRESPONDING sdyn_conn TO wa_sflight.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_BOOKINGS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_bookings OUTPUT.
  IF it_book IS INITIAL.
    CREATE OBJECT con EXPORTING container_name = 'CON'.
    CREATE OBJECT alv EXPORTING i_parent = con.
    SELECT * FROM sbook INTO table it_book WHERE carrid = sdyn_conn-carrid
      AND connid = sdyn_conn-connid
      AND fldate = sdyn_conn-fldate.

      alv->set_table_for_first_display(
        EXPORTING
          i_structure_name              =  'SBOOK'   " Internal Output Table Structure Name
       CHANGING
          it_outtab                     =  it_book ).   " Output Table
    ENDIF.
ENDMODULE.
