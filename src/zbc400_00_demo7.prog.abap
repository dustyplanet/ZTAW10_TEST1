*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo7.

PARAMETERS: pa_name TYPE string.

PERFORM sub_demo using pa_name. "Pa_name is the actual parameter
PERFORM sub_demo using 'Demo 2'. "'Demo 2' is the actual parameter


FORM sub_demo using p_text type string. "p_text = formal parameter
  WRITE:/ 'Hello subroutine -', p_text.
ENDFORM.
