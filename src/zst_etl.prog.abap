*&---------------------------------------------------------------------*
*& Report zst_etl
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zst_etl.




START-OF-SELECTION.

  DATA(temp_cl) = NEW zst_etl( ).

  DATA(legacy_to_newshiny) = temp_cl->transform( legacy_data = VALUE #(
*                                                                      ( number = 1 string = `A` )
*                                                                      ( number = 1  string = `A,E,I,O,U` )
                                                                       ( number = 1  string = `A,E` )
                                                                       ( number = 2  string = `D,G` )
                                                                       ) ).
  BREAK-POINT.
