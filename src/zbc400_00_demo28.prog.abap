*&---------------------------------------------------------------------*
*& Report ZBC400_00_DEMO27
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_00_demo28.
PARAMETERS : pa_car TYPE bc400_s_flight-carrid DEFAULT 'AA',
             pa_con TYPE bc400_s_flight-connid DEFAULT '0017',
             pa_dat TYPE bc400_s_flight-fldate. " DEFAULT sy-datum + 1.
DATA: it_book TYPE TABLE OF sbook,
      wa_book TYPE sbook.

INITIALIZATION.
  pa_dat = sy-datum + 7.

AT SELECTION-SCREEN.
  AUTHORITY-CHECK OBJECT 'S_CARRID'
         ID 'CARRID' FIELD pa_car
         ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    MESSAGE e046(bc400) WITH pa_car.
  ENDIF.

START-OF-SELECTION.
  SELECT * FROM sbook INTO TABLE it_book WHERE carrid = pa_car AND connid = pa_con AND fldate = pa_dat.
  LOOP AT it_book INTO wa_book.
    WRITE:/ wa_book-carrid,
            wa_book-connid,
            wa_book-fldate,
            wa_book-bookid,
            wa_book-passname,
            wa_book-customid.
  ENDLOOP.
