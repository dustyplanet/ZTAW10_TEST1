*&---------------------------------------------------------------------*
*& Report  BC400_RPT_REP_A
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT  zbc400_00_demo29.

DATA:
  gt_flights TYPE bc400_t_flights,
  gs_flight  TYPE bc400_s_flight.

PARAMETERS:
     pa_car TYPE bc400_s_flight-carrid.
SELECT-OPTIONS: so_conn FOR gs_flight-connid.

INITIALIZATION.
  pa_car = 'LH'.


AT SELECTION-SCREEN.
  TRY.
      cl_bc400_flightmodel=>check_authority(
          iv_carrid   = pa_car
          iv_activity = '03'
             ).
    CATCH cx_bc400_no_auth .
      MESSAGE e046(bc400) WITH pa_car.
  ENDTRY.

START-OF-SELECTION.
  TRY.
      cl_bc400_flightmodel=>get_flights_range(
        EXPORTING
          iv_carrid  = pa_car
          it_connid  = so_conn[]
        IMPORTING
          et_flights = gt_flights
             ).

    CATCH cx_bc400_no_data.
      WRITE / 'No flights for the specified connection'.
    CATCH cx_bc400_no_auth .
      WRITE:/ 'Not authorized'.
  ENDTRY.

  LOOP AT gt_flights INTO gs_flight.
    IF gs_flight-percentage > 95.
      WRITE: / icon_red_light AS ICON.
    ELSEIF gs_flight-percentage > 50.
      WRITE:/ icon_yellow_light AS ICON.
    ELSE.
      WRITE:/ icon_green_light AS ICON.
    ENDIF.

    WRITE: gs_flight-carrid COLOR COL_KEY,
       gs_flight-connid COLOR COL_KEY,
       gs_flight-fldate COLOR COL_KEY,
       gs_flight-seatsmax,
       gs_flight-seatsocc,
       gs_flight-percentage.

  ENDLOOP.
