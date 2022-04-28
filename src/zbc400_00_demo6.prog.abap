*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo6.

PARAMETERS: pa_name TYPE string.

PERFORM sub_demo.
PERFORM sub_demo.
PERFORM sub_demo.


FORM sub_demo.
  WRITE:/ 'Hello subroutine'.
ENDFORM.
