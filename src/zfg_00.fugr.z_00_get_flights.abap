FUNCTION z_00_get_flights.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_CARRID) TYPE  S_CARR_ID
*"     REFERENCE(IV_CONNID) TYPE  S_CONN_ID
*"  EXPORTING
*"     REFERENCE(EV_FLIGHTS) TYPE  BC400_T_FLIGHTS
*"  EXCEPTIONS
*"      NO_DATA
*"----------------------------------------------------------------------

  DATA: wa_flight TYPE bc400_s_flight.

  REFRESH ev_flights.
  SELECT * FROM sflight INTO CORRESPONDING FIELDS OF wa_flight WHERE carrid = iv_carrid AND connid = iv_connid.
    wa_flight-percentage = wa_flight-seatsocc * 100 / wa_flight-seatsmax.
    APPEND wa_flight TO ev_flights.
  ENDSELECT.
  IF sy-subrc NE 0.
    RAISE no_data.
  ENDIF.




ENDFUNCTION.
