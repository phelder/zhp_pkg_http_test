CLASS zcl_rest_get_hp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rest_get_hp IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    TRY.
        DATA(destination) = cl_http_destination_provider=>create_by_url(
            i_url = 'https://jsonplaceholder.typicode.com/posts/1'
        ).

        DATA(client) = cl_web_http_client_manager=>create_by_http_destination(
            i_destination = destination
        ).

        DATA(response) = client->execute( i_method = if_web_http_client=>get ).

        out->write( response->get_status(  ) ).
        DATA(body) = response->get_text(  ).


        client->close(  ).

      CATCH cx_root INTO DATA(error).

        out->write( |ABAP / connection error: { error->get_text( ) }| ).
    ENDTRY.


    TYPES: BEGIN OF ty_post,
             userid TYPE i,
             id      TYPE i,
             title   TYPE string,
             body    TYPE string,
           END OF ty_post.

    DATA(post) = VALUE ty_post( ).

    TRY.
        xco_cp_json=>data->from_string( body )->write_to( REF #( post ) ).

        out->write( post ).

    CATCH cx_root INTO DATA(error_json).
        out->write( error_json ).

    ENDTRY.

*    TRY.
*        DATA(destination) = cl_http_destination_provider=>create_by_url(
*            i_url = 'https://webhook.site/ddc93d1b-ea2d-4e30-8293-57902d0beb7d'
*        ).
*
*        DATA(client) = cl_web_http_client_manager=>create_by_http_destination(
*            i_destination = destination
*        ).
*
*        DATA(request) = client->get_http_request( ).
*        request->set_header_field(
*            i_name = 'Accept'
*            i_value = 'application/json'
*        ).
**        request->set_header_field(
**            i_name = 'content-type'
**            i_value = 'application/json; charset=UTF-8'
**        ).
*        request->set_content_type( 'application/json; charset=UTF-8' ).
*        request->set_text( '{"title":"Stock-check training","body":"Created from ABAP","userId":1}' ).
*
*        DATA(response) = client->execute( i_method = if_web_http_client=>post ).
*
*        out->write( response->get_status(  ) ).
*        out->write( response->get_text(  ) ).
*
*        client->close(  ).
*
*      CATCH cx_root INTO DATA(error).
*
*        out->write( |ABAP / connection error: { error->get_text( ) }| ).
*    ENDTRY.

  ENDMETHOD.

ENDCLASS.
