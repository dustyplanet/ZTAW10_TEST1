*&---------------------------------------------------------------------*
*& Report  SAPBC430S_DATA_ELEMENTS                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  zbc430s_00_data_elements.

**Replace ## by Your group- or screennumber and
**uncomment the ABAP-coding

DATA:       result   TYPE zassets00.

PARAMETERS: pa_fname TYPE zfirstname00,
            pa_lname TYPE zlastname00,
            pa_activ TYPE zassets00,
            pa_liabs TYPE zliabilities00.

START-OF-SELECTION.

  NEW-LINE.
  WRITE: 'Client:', pa_fname, pa_lname.

  result = pa_activ - pa_liabs.

  NEW-LINE.
  WRITE: 'Finance:', pa_activ, pa_liabs, result.
