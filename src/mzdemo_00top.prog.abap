*&---------------------------------------------------------------------*
*& Include MZDEMO_00TOP                                      Module Pool      SAPMZDEMO_00
*&
*&---------------------------------------------------------------------*
PROGRAM sapmzdemo_00.
TABLES: SDYN_CONN. "SCreen structure
DATA: wa_sflight type sflight,
      wa_spfli type spfli. "Program Structure
DATA: ok_code type sy-ucomm, carrname type scarr-carrname,
      mod_flag, icon1 type icons-text.
