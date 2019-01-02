module Api exposing (ApiMsg(..), apiUpdate)

import Http


type ApiMsg
    = Request
    | Response (Result Http.Error String)


apiUpdate : { model | text : String } -> ApiMsg -> ( { model | text : String }, Cmd msg )
apiUpdate model msg =
    case msg of
        Request ->
            ( model
            , Http.get
                { url = "/tables.json"
                , expect = Http.expectString Response
                }
            )

        Response result ->
            case result of
                Ok str ->
                    ( { model | text = str }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )
