*&---------------------------------------------------------------------*
*& Report  BC400_MOS_SUBROUTINE                                        *
*&---------------------------------------------------------------------*
REPORT  zbc400_00_demo14 .

TYPES tv_result TYPE p LENGTH 16 DECIMALS 2.


PARAMETERS:
  pa_int1 TYPE i,
  pa_op   TYPE c LENGTH 1,
  pa_int2 TYPE i.

DATA gv_result TYPE tv_result.

IF ( pa_op = '+' OR
     pa_op = '-' OR
     pa_op = '*' OR
     pa_op = '/' AND pa_int2 <> 0 OR
     pa_op = '%' OR
     pa_op = 'P' ).

  CASE pa_op.
    WHEN '+'.
      gv_result = pa_int1 + pa_int2.
    WHEN '-'.
      gv_result = pa_int1 - pa_int2.
    WHEN '*'.
      gv_result = pa_int1 * pa_int2.
    WHEN '/'.
      gv_result = pa_int1 / pa_int2.
    WHEN '%'.
      CALL FUNCTION 'Z_CAL_PERCENTAGE_00'
        EXPORTING
          iv_act      = pa_int1
          iv_max      = pa_int2
        IMPORTING
          ev_result   = gv_result
        EXCEPTIONS
          zero_divide = 1.
      IF sy-subrc = 1.
        WRITE:/ 'Max value cannot be zero' COLOR COL_NEGATIVE.
      ENDIF.
    WHEN 'P'.
      CALL FUNCTION 'BC400_MOS_POWER'
        EXPORTING
          iv_base               = pa_int1
          iv_power              = pa_int2
        IMPORTING
          ev_result             = gv_result
        EXCEPTIONS
          power_value_too_high  = 1
          result_value_too_high = 2.

      IF sy-subrc = 1.
        WRITE:/ 'Use a value less than 4 for the power' COLOR COL_NEGATIVE.
      ELSEIF sy-subrc = 2.
        WRITE:/ 'Use smaller numbers' COLOR COL_NEGATIVE.
      ENDIF.
  ENDCASE.

  WRITE: 'Result:'(res), gv_result.

ELSEIF  pa_op = '/'  AND  pa_int2 = 0.
  WRITE: 'No division by zero!'(dbz).
ELSE.
  WRITE: 'Invalid operator!'(iop).
ENDIF.
