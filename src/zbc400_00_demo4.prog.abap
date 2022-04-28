*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo4.
PARAMETERS: pa_carr TYPE scarr-carrid.
DATA: wa_scarr TYPE scarr.

SELECT SINGLE * FROM scarr INTO wa_scarr WHERE carrid = pa_carr.
IF sy-subrc = 0.
  WRITE:/ 'Airline :', wa_scarr-carrid,
                       wa_scarr-carrname.
ELSE.
*  MESSAGE i041(bc400) WITH pa_carr.
  message 'Airline not found' type 'I'.
ENDIF.
