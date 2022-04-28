*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO9
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo12.
DATA: a TYPE i, b TYPE i, c TYPE i, d type i.
MOVE 1 TO: a, b, c, d.
WRITE:/ a, b, c, d. "1 1 1 1
*PERFORM sub USING a b CHANGING c d. "Actual parameters
*PERFORM sub USING a b c CHANGING d. "Actual parameters
PERFORM sub USING a b c d. "Actual parameters

WRITE:/ a, b, c, d.

FORM sub USING    VALUE(p1) TYPE i "Pass by value
                        p2  type i "Pass by reference
         CHANGING       p3  TYPE i "Pass by reference
                  VALUE(p4) TYPE i."Pass by value and result
  WRITE:/ a, b, c, d.
  MOVE 2 TO: p1, p2, p3, p4.
  WRITE:/ a, b, c, d.
ENDFORM.
