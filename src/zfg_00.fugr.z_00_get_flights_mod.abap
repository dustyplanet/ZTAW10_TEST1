FUNCTION z_00_get_flights_mod.
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
  SELECT * FROM sflight INTO CORRESPONDING FIELDS OF TABLE ev_flights WHERE carrid = iv_carrid AND connid = iv_connid.

  IF sy-subrc NE 0.
    RAISE no_data.
  ELSE.

    LOOP AT ev_flights INTO wa_flight.
      wa_flight-percentage = wa_flight-seatsocc * 100 / wa_flight-seatsmax.
      MODIFY ev_flights FROM wa_flight INDEX sy-tabix.
    ENDLOOP.
  ENDIF.

ENDFUNCTION.
