CLASS zst_etl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_legacy_data,
        number TYPE i,
        string TYPE string,
      END OF ty_legacy_data,
      BEGIN OF ty_new_data,
        letter TYPE c LENGTH 1,
        number TYPE i,
      END OF ty_new_data,
      tty_legacy_data TYPE SORTED TABLE OF ty_legacy_data WITH UNIQUE KEY number,
      tty_new_data    TYPE SORTED TABLE OF ty_new_data WITH UNIQUE KEY letter.

    METHODS transform IMPORTING VALUE(legacy_data) TYPE tty_legacy_data
                      RETURNING VALUE(new_data)    TYPE tty_new_data.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zst_etl IMPLEMENTATION.
  METHOD transform.

    " loop at legacy_data
    " get the string translate to lower
    " read new data table into structure
    " letter eq string
    " number eq number
    DATA: ls_newdata TYPE ty_new_data,
          lv_offset  TYPE i,
          lt_letters TYPE string_table.

    LOOP AT legacy_data ASSIGNING FIELD-SYMBOL(<lfs_legacy>).

      REPLACE ALL OCCURRENCES OF REGEX `[^a-zA-Z]` IN <lfs_legacy>-string WITH ``.
      lv_offset = 0.
      CLEAR: lt_letters.

      DO strlen( <lfs_legacy>-string ) TIMES.
        DATA(lv_oneletter) = to_lower( substring( val = <lfs_legacy>-string off = lv_offset len = 1 ) ).
        APPEND lv_oneletter TO lt_letters.
        lv_offset += 1.
      ENDDO.

      LOOP AT lt_letters ASSIGNING FIELD-SYMBOL(<lfs_letter>).
        ls_newdata-letter = <lfs_letter>.
        ls_newdata-number = <lfs_legacy>-number.
        INSERT ls_newdata INTO TABLE new_data.
      ENDLOOP.
    ENDLOOP.

    " alternative solution
*    LOOP AT legacy_data INTO DATA(legacy).
*      legacy-string = to_lower( legacy-string ).
*      SPLIT legacy-string AT `,` INTO TABLE DATA(letters).
*      LOOP AT letters INTO DATA(letter).
*        INSERT VALUE #( letter = letter
*                        number = legacy-number ) INTO TABLE new_data.
*      ENDLOOP.
*    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
