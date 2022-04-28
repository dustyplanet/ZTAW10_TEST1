FUNCTION z_cal_percentage_00.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_ACT) TYPE  BC400_ACT
*"     REFERENCE(IV_MAX) TYPE  BC400_MAX
*"  EXPORTING
*"     REFERENCE(EV_RESULT) TYPE  BC400_PERC
*"  EXCEPTIONS
*"      ZERO_DIVIDE
*"----------------------------------------------------------------------

  IF iv_max = 0.
    RAISE zero_divide.
  ELSE.
    ev_result = iv_act * 100 / iv_max.
  ENDIF.



ENDFUNCTION.
