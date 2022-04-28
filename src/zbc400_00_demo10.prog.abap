*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo10.
TYPES: t_result TYPE p LENGTH 16 DECIMALS 2.
PARAMETERS: pa1   TYPE i,
            pa_op TYPE c,
            pa2   TYPE i.
DATA: result TYPE t_result.

IF pa_op = '+' OR pa_op = '-' OR pa_op = '*' OR  pa_op = '/'.
  PERFORM cal_sub USING pa1 pa_op pa2
                  CHANGING result.

  WRITE:/ 'The result is = ', result.
ELSE.
  WRITE:/ 'Invalid operator'.
ENDIF.



FORM cal_sub USING VALUE(p1) TYPE i   "Formal parameters
                   VALUE(p_op) TYPE c
                   VALUE(p2) TYPE i
                 CHANGING p3 TYPE t_result.

  CASE p_op.
    WHEN '+'.
      result = p1 + p2.
    WHEN '-'.
      result = p1 - p2.
    WHEN '*'.
      result = p1 * p2.
    WHEN '/'.
      IF p2 NE 0.
        result = p1 / p2.
      ELSE.
        WRITE:/ 'Cannot divide by zero'.
      ENDIF.
  ENDCASE.
ENDFORM.
