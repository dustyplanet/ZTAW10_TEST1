*&---------------------------------------------------------------------*
*& Report  SAPBC430S_STRUCT_NESTED                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  zbc430s_00_struct                                     .

*Replace ## by Your group- or screennumber and
*uncomment the ABAP-coding

DATA wa_person TYPE zperson00.

START-OF-SELECTION.

  wa_person-name-firstname = 'Harry'.
  wa_person-name-lastname = 'Potter'.

  wa_person-street = 'Privet Drive'.
  wa_person-nr = '3'.
  wa_person-zip = 'GB-10889'.
  wa_person-city = 'London'.

  WRITE: /  wa_person-name-firstname ,
            wa_person-name-lastname ,
            wa_person-street ,
            wa_person-nr ,
            wa_person-zip ,
            wa_person-city .
