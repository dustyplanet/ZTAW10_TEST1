*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO17
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo24.

PARAMETERS : pa_car TYPE bc400_s_flight-carrid,
             pa_con TYPE bc400_s_flight-connid.

DATA: wa_flight TYPE bc400_s_flight,
      it_flight TYPE bc400_t_flights.

AUTHORITY-CHECK OBJECT 'S_CARRID'
         ID 'CARRID' FIELD pa_car
         ID 'ACTVT' FIELD '03'.
IF sy-subrc <> 0.
  WRITE:/ 'Not authorized' COLOR COL_NEGATIVE.
ELSE.

  SELECT carrid connid fldate seatsmax seatsocc FROM sflight INTO CORRESPONDING FIELDS OF TABLE it_flight
                        WHERE carrid = pa_car
                        AND connid = pa_con.


  LOOP AT it_flight INTO wa_flight.

    wa_flight-percentage = wa_flight-seatsocc * 100 / wa_flight-seatsmax.

    WRITE:/ sy-vline,
            wa_flight-carrid,
            AT 10 sy-vline, wa_flight-connid COLOR COL_KEY,
            AT 25 sy-vline,  wa_flight-fldate COLOR COL_KEY,
            AT 45  sy-vline, wa_flight-seatsmax,
            AT 55  sy-vline, wa_flight-seatsocc,  sy-vline.
    IF wa_flight-percentage > 95.
      WRITE AT 65 wa_flight-percentage COLOR COL_NEGATIVE INTENSIFIED.
    ELSEIF wa_flight-percentage > 50.
      WRITE AT 65 wa_flight-percentage COLOR COL_TOTAL INTENSIFIED.
    ELSE.
      WRITE AT 65 wa_flight-percentage COLOR COL_POSITIVE INTENSIFIED.
    ENDIF.
    write sy-vline..
    NEW-LINE.
    ULINE (80).
  ENDLOOP.
ENDIF.
