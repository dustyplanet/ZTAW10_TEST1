*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo8.
PARAMETERS: pa_op1 TYPE i,
            pa_op2 TYPE i.

DATA: result TYPE i.

PERFORM add_numbers USING pa_op1 pa_op2 CHANGING result. "Actual parameters
WRITE:/ 'Result is - ', result.
PERFORM add_numbers USING 10 20 CHANGING result.
WRITE:/ 'Result is - ', result.


FORM add_numbers USING VALUE(p1) TYPE i   "Formal parameters
                       VALUE(p2) TYPE i
                 CHANGING    p3  TYPE i.

  p3 = p1 + p2.
ENDFORM.
