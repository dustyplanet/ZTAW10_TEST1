*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO17
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo17.
TYPES: BEGIN OF t_carflight,
         carrid     TYPE bc400_s_carrier-carrid,
         carrname   TYPE bc400_s_carrier-carrname,
         currcode   TYPE bc400_s_carrier-currcode,
         url        TYPE bc400_s_carrier-url,
         connid     TYPE  bc400_s_flight-connid,
         fldate     TYPE bc400_s_flight-fldate,
         seatsmax   TYPE bc400_s_flight-seatsmax,
         seatsocc   TYPE bc400_s_flight-seatsocc,
         percentage TYPE bc400_s_flight-percentage,
       END OF t_carflight.
PARAMETERS : pa_car TYPE bc400_s_flight-carrid,
             pa_con TYPE bc400_s_flight-connid,
             pa_dat TYPE bc400_s_flight-fldate.

DATA: wa_car       TYPE bc400_s_carrier,
      wa_flight    TYPE bc400_s_flight,
      wa_carflight TYPE t_carflight.


TRY.
    cl_bc400_flightmodel=>get_flight(
      EXPORTING
        iv_carrid = pa_car
        iv_connid = pa_con
        iv_fldate = pa_dat
      IMPORTING
        es_flight = wa_flight
           ).
    cl_bc400_flightmodel=>get_carrier(
    EXPORTING
      iv_carrid  = pa_car
    IMPORTING
      es_carrier = wa_car
         ).
  CATCH cx_bc400_no_data .
    WRITE:/ 'No Data found'.
  CATCH cx_bc400_no_auth .
    WRITE:/ 'Not authorized'.

ENDTRY.

MOVE-CORRESPONDING wa_car TO wa_carflight.
MOVE-CORRESPONDING wa_flight TO wa_carflight.

WRITE:/ wa_carflight-carrid,
wa_carflight-carrname,
wa_carflight-currcode,
wa_carflight-fldate,
wa_carflight-seatsmax,
wa_carflight-seatsocc,
wa_carflight-percentage.
