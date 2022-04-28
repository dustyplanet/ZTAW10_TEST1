*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO30
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo30.
TYPES: BEGIN OF ty_flight,
         carrid   TYPE sflight-carrid,
         carrname TYPE scarr-carrname,
         connid   TYPE sflight-connid,
         cityfrom TYPE spfli-cityfrom,
         cityto   TYPE spfli-cityto,
         fldate   TYPE sflight-fldate,
         seatsocc TYPE sflight-seatsocc,
         seatsmax TYPE sflight-seatsmax,
       END OF ty_flight.

PARAMETERS: pa_car TYPE sflight-carrid,
            pa_con TYPE sflight-connid.

DATA: wa_flight TYPE ty_flight,
      it_flight TYPE TABLE OF ty_flight.

START-OF-SELECTION.

  SELECT f~carrid
         c~carrname
         f~connid
         p~cityfrom
         p~cityto
         f~fldate
         f~seatsocc
         f~seatsmax INTO TABLE it_flight
                    FROM sflight AS f INNER JOIN scarr AS c ON f~carrid = c~carrid
                                      INNER JOIN spfli AS p ON f~carrid = p~carrid AND f~connid = p~connid
                    WHERE f~carrid = pa_car AND f~connid = pa_con.

  LOOP AT it_flight INTO wa_flight.
    WRITE:/ wa_flight-carrid, wa_flight-carrname, wa_flight-connid, wa_flight-cityfrom, wa_flight-cityto,
    wa_flight-fldate, wa_flight-seatsocc, wa_flight-seatsmax.
  ENDLOOP.
