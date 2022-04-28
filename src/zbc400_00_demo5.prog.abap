*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo5.
PARAMETERS: pa1   TYPE i,
            pa_op TYPE c,
            pa2   TYPE i.
DATA: result TYPE p LENGTH 16 DECIMALS 2.
IF pa_op = '+' OR pa_op = '-' OR pa_op = '*' OR  pa_op = '/'.

  CASE pa_op.
    WHEN '+'.
      result = pa1 + pa2.
    WHEN '-'.
      result = pa1 - pa2.
    WHEN '*'.
      result = pa1 * pa2.
    WHEN '/'.
      IF pa2 NE 0.
        result = pa1 / pa2.
      ELSE.
        WRITE:/ 'Cannot divide by zero'.
      ENDIF.
  ENDCASE.
  WRITE:/ 'The result is = ', result.
ELSE.
  WRITE:/ 'Invalid operator'.
ENDIF.
