*&---------------------------------------------------------------------*
*& Include MZDEMO_00TOP                                      Module Pool      SAPMZDEMO_00
*&
*&---------------------------------------------------------------------*
PROGRAM sapmzdemo_00.
TABLES: sdyn_conn, spfli, saplane. "SCreen structure
DATA: wa_sflight TYPE sflight,
      wa_spfli   TYPE spfli. "Program Structure
DATA: ok_code  TYPE sy-ucomm, carrname TYPE scarr-carrname,
      mod_flag, icon1 TYPE icons-text.

CONTROLS: tab TYPE TABSTRIP.
