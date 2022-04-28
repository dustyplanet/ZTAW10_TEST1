*&---------------------------------------------------------------------*
*&  Include           MZBC410_SOLUTION_00E01
*&---------------------------------------------------------------------*
LOAD-OF-PROGRAM.
  GET PARAMETER ID 'CAR' FIELD sdyn_conn-carrid.
  GET PARAMETER ID 'CON' FIELD sdyn_conn-connid.
  GET PARAMETER ID 'DAY' FIELD sdyn_conn-fldate.
  SELECT SINGLE * FROM sflight INTO wa_sflight WHERE carrid = sdyn_conn-carrid
                                                 AND connid = sdyn_conn-connid
                                                 AND fldate = sdyn_conn-fldate.
