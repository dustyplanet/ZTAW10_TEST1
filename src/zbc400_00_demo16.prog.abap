*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO16
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo16.
*TYPES: begin of t_flight,
*       carrid type sflight-carrid,
*       connid type sflight-connid,
*       fldate type sflight-fldate,
*      end of t_flight.
*DATA: wa_flight TYPE sflight.        "DB Table
*DATA: wa_flight TYPE bc400_s_flight. "Structured Type - Dictionary
*DATA: wa_flight type t_flight.       "Local Structured Type
DATA: BEGIN OF wa_flight,             "Custom structure
        carrid TYPE sflight-carrid,
        connid TYPE sflight-connid,
        fldate TYPE sflight-fldate,
      END OF wa_flight.


wa_flight-carrid = 'AA'.
wa_flight-connid = '0017'.
