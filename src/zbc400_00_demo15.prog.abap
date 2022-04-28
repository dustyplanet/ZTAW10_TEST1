*&---------------------------------------------------------------------*
*& Report  BC400_MOS_SUBROUTINE                                        *
*&---------------------------------------------------------------------*
REPORT  zbc400_00_demo15 .

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
      TRY.
          cl_bc400_compute=>get_power(
            EXPORTING
              iv_base   = pa_int1
              iv_power  = pa_int2
            IMPORTING
              ev_result = gv_result
                 ).
        CATCH cx_bc400_power_too_high .
          WRITE:/ 'Power cannot be higher than 4'.
        CATCH cx_bc400_result_too_high .
          WRITE:/ 'Result is too large, use smaller numbers'.
      ENDTRY.



  ENDCASE.

  WRITE: 'Result:'(res), gv_result.

ELSEIF  pa_op = '/'  AND  pa_int2 = 0.
  WRITE: 'No division by zero!'(dbz).
ELSE.
  WRITE: 'Invalid operator!'(iop).
ENDIF.
