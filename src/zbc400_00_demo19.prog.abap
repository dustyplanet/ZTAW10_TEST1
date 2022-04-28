*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO18
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo19.
PARAMETERS: pa_car TYPE sflight-carrid,
            pa_con TYPE sflight-connid.

DATA: it_flight TYPE bc400_t_flights,
      wa_flight TYPE bc400_s_flight.
TRY.
    cl_bc400_flightmodel=>get_flights(
      EXPORTING
        iv_carrid  = pa_car
        iv_connid  = pa_con
      IMPORTING
        et_flights = it_flight
           ).
  CATCH cx_bc400_no_data .
    WRITE:/ 'No flight found'.
  CATCH cx_bc400_no_auth .
    WRITE:/ 'Not authorized'.
ENDTRY.
SORT it_flight BY percentage.
LOOP AT it_flight INTO wa_flight TO 10.
  WRITE:/ sy-tabix,
  wa_flight-carrid,
          wa_flight-connid,
          wa_flight-fldate,
          wa_flight-seatsmax,
          wa_flight-seatsocc,
          wa_flight-percentage.
ENDLOOP.
