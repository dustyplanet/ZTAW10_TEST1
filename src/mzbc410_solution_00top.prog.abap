*&---------------------------------------------------------------------*
*& Include MZBC410_SOLUTION_00TOP                            Module Pool      SAPMZBC410_SOLUTION_00
*&
*&---------------------------------------------------------------------*
PROGRAM sapmzbc410_solution_00.
TABLES: sdyn_conn.
DATA: wa_sflight TYPE sflight,
      ok_code    TYPE sy-ucomm,
      r1 value 'X', r2, r3.
