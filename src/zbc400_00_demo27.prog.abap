*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO27
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo27.
PARAMETERS : pa_car TYPE bc400_s_flight-carrid,
             pa_con TYPE bc400_s_flight-connid.
DATA: it_flight TYPE bc400_t_flights,
      wa_flight TYPE bc400_s_flight.

AUTHORITY-CHECK OBJECT 'S_CARRID'
         ID 'CARRID' FIELD pa_car
         ID 'ACTVT' FIELD '03'.
IF sy-subrc <> 0.
  WRITE:/ 'No authorization'.
ELSE.
  SELECT * FROM sflight INTO CORRESPONDING FIELDS OF wa_flight WHERE carrid = pa_car AND connid = pa_con.
    wa_flight-percentage = wa_flight-seatsocc * 100 / wa_flight-seatsmax.
    APPEND wa_flight TO it_flight.
  ENDSELECT.
  SORT it_flight BY percentage DESCENDING.
  LOOP AT it_flight INTO wa_flight.

    WRITE:/ wa_flight-carrid,
            wa_flight-connid,
            wa_flight-fldate,
            wa_flight-seatsocc,
            wa_flight-seatsmax,
            wa_flight-percentage.
  ENDLOOP.
ENDIF.
