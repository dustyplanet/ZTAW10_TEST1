*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO9
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo9.
DATA: a TYPE i, b TYPE i, c TYPE i.
MOVE 1 TO: a, b, c.
WRITE:/ a, b, c. "1 1 1
PERFORM sub USING a CHANGING b c. "Actual parameters
WRITE:/ a, b, c. "1 2 2

FORM sub USING    VALUE(p1) TYPE i "Pass by value
         CHANGING       p2  TYPE i "Pass by reference
                  VALUE(p3) TYPE i."Pass by value and result
  WRITE:/ a, b, c."1 1 1
  MOVE 2 TO: p1, p2, p3.
  WRITE:/ a, b, c."1 2 1
ENDFORM.
