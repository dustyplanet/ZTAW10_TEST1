FUNCTION Z_00_GET_CONNECTION .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_CARRID) TYPE  S_CARR_ID
*"     REFERENCE(IV_CONNID) TYPE  S_CONN_ID
*"  EXPORTING
*"     REFERENCE(EV_CONNECTION) TYPE  BC400_S_CONNECTION
*"  EXCEPTIONS
*"      NO_DATE
*"----------------------------------------------------------------------

  SELECT SINGLE * FROM spfli INTO CORRESPONDING FIELDS OF ev_connection WHERE carrid = iv_carrid AND connid = iv_connid.
  IF sy-subrc NE 0.
    RAISE no_data.
  ENDIF.



ENDFUNCTION.
