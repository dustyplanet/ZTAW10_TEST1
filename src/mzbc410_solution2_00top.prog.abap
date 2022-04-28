*&---------------------------------------------------------------------*
*& Include MZBC410_SOLUTION_00TOP                            Module Pool      SAPMZBC410_SOLUTION_00
*&
*&---------------------------------------------------------------------*
PROGRAM sapmzbc410_solution_00.
TABLES: sdyn_conn, saplane.
DATA: wa_sflight TYPE sflight,
      ok_code    TYPE sy-ucomm,carrname type scarr-carrname,
      mod_flag,icon1 type icons-text,
      r1 value 'X', r2, r3,
      dynnr type sy-dynnr value '0110',
      alv type ref to cl_gui_alv_grid,
      con type ref to cl_gui_custom_container,
      it_book type table of sbook.
CONTROLS: tab type tabstrip.
