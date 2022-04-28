*&---------------------------------------------------------------------*
*& Report  BC402_DBT_3JOIN
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zbc402_01_3join.

TYPES: BEGIN OF gty_s_booking,
         carrid    TYPE sbook-carrid,
         carrname  TYPE scarr-carrname,
         connid    TYPE sbook-connid,
         fldate    TYPE sbook-fldate,
         bookid    TYPE sbook-bookid,
         customid  TYPE sbook-customid,
         agencynum TYPE sbook-agencynum,
         name      TYPE stravelag-name,
         city      TYPE stravelag-city,
       END OF gty_s_booking.

TYPES:
   gty_t_bookings TYPE STANDARD TABLE OF gty_s_booking
                       WITH NON-UNIQUE KEY
                       carrid connid fldate bookid.

DATA:
  gt_bookings TYPE gty_t_bookings,
  gs_booking  TYPE gty_s_booking.

DATA:
  gv_custname   TYPE scustom-name,
  gv_carrname   TYPE scarr-carrname,
  gv_agencyname TYPE stravelag-name,
  gv_agencycity TYPE stravelag-city.

FIELD-SYMBOLS:
  <fs_booking> LIKE LINE OF gt_bookings.

SELECT-OPTIONS :
      so_agy FOR gs_booking-agencynum DEFAULT '100',
      so_cus FOR gs_booking-customid,
      so_fld FOR gs_booking-fldate.


START-OF-SELECTION.

  SELECT
    s~carrid c~carrname s~connid s~fldate s~bookid s~customid s~agencynum a~name a~city
    INTO TABLE gt_bookings
    FROM sbook AS s INNER JOIN scarr AS c ON s~carrid = c~carrid
               LEFT OUTER JOIN stravelag AS a ON s~agencynum = a~agencynum
               WHERE s~agencynum IN so_agy AND
                 s~customid  IN so_cus AND
                 s~fldate    IN so_fld AND
                 s~cancelled <> 'X'.
*  SELECT carrid connid fldate bookid
*         customid agencynum
*         FROM sbook
*         INTO TABLE gt_bookings
*         WHERE agencynum IN so_agy AND
*               customid  IN so_cus AND
*               fldate    IN so_fld AND
*               cancelled <> 'X'.

  LOOP AT gt_bookings ASSIGNING <fs_booking>.

    SELECT SINGLE name FROM scustom INTO gv_custname
           WHERE id = <fs_booking>-customid.

*    SELECT SINGLE carrname FROM scarr
*           INTO gv_carrname
*           WHERE carrid = <fs_booking>-carrid.
*
*    SELECT SINGLE name city FROM stravelag
*           INTO (gv_agencyname, gv_agencycity)
*           WHERE agencynum = <fs_booking>-agencynum.



    WRITE: /
        <fs_booking>-carrid,
        <fs_booking>-carrname,
        <fs_booking>-connid,
        <fs_booking>-fldate,
        <fs_booking>-bookid,
        gv_custname,
        <fs_booking>-name,
        <fs_booking>-city.

  ENDLOOP.
