FUNCTION z_00_authcheck.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_CARRID) TYPE  S_CARR_ID
*"     REFERENCE(IV_ACTVT) TYPE  ACTIV_AUTH
*"  EXCEPTIONS
*"      NO_AUTH
*"      INVALID_ACTVT
*"----------------------------------------------------------------------
  CASE iv_actvt.
    WHEN '01' OR '02' OR '03'.
      AUTHORITY-CHECK OBJECT 'S_CARRID'
               ID 'CARRID' FIELD iv_carrid
               ID 'ACTVT' FIELD iv_actvt.
      IF sy-subrc <> 0.
        RAISE no_auth.
      ENDIF.
    WHEN OTHERS.
      RAISE invalid_actvt.
  ENDCASE.




ENDFUNCTION.
