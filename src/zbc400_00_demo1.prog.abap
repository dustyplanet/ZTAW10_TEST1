*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo1.
*This is a comment
PARAMETERS pa_name TYPE string.

DATA greeting TYPE string.
*
*CONCATENATE 'Hello ' pa_name INTO greeting SEPARATED BY space.
WRITE: 'Hello World!',
        pa_name.
*WRITE greeting. "This is an inline comment
