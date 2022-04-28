*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO17
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo20.

PARAMETERS : pa_car TYPE bc400_s_flight-carrid,
             pa_con TYPE bc400_s_flight-connid,
             pa_dat TYPE bc400_s_flight-fldate.

DATA: wa_flight    TYPE bc400_s_flight.

SELECT SINGLE * FROM sflight INTO CORRESPONDING FIELDS OF wa_flight
                      WHERE carrid = pa_car
  AND connid = pa_con
  AND fldate = pa_dat.

wa_flight-percentage = wa_flight-seatsocc * 100 / wa_flight-seatsmax.
WRITE:/ wa_flight-carrid,
wa_flight-connid,
wa_flight-fldate,
wa_flight-seatsmax,
wa_flight-seatsocc,
wa_flight-percentage.
