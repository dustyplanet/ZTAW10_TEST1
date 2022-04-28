*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO17
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo22.

PARAMETERS : pa_car TYPE bc400_s_flight-carrid,
             pa_con TYPE bc400_s_flight-connid.

DATA: wa_flight TYPE bc400_s_flight,
      it_flight TYPE bc400_t_flights.

SELECT carrid connid fldate seatsmax seatsocc FROM sflight INTO CORRESPONDING FIELDS OF TABLE it_flight
                      WHERE carrid = pa_car
                      AND connid = pa_con.


LOOP AT it_flight INTO wa_flight.

  wa_flight-percentage = wa_flight-seatsocc * 100 / wa_flight-seatsmax.
  WRITE:/ wa_flight-carrid,
          wa_flight-connid,
  wa_flight-fldate,
  wa_flight-seatsmax,
  wa_flight-seatsocc,
  wa_flight-percentage.

ENDLOOP.
