*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO18
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo18.
TYPES: BEGIN OF t_flight,
         carrid     TYPE sflight-carrid,
         connid     TYPE sflight-connid,
         fldate     TYPE sflight-fldate,
         seatsmax   TYPE sflight-seatsmax,
         seatsocc   TYPE sflight-seatsocc,
         percentage TYPE p LENGTH 5 DECIMALS 2,
       END OF t_flight,
       ty_tab_flight type table of t_flight.
DATA: it_flight TYPE TABLE OF sflight.
DATA: it_flight2 TYPE TABLE OF bc400_s_flight.
DATA: it_flight3 TYPE TABLE OF t_flight.
DATA: it_flight4 TYPE bc400_t_flights.
DATA: it_flight5 TYPE ty_tab_flight.
