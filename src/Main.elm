module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Url



---- MODEL ----


type alias Model =
    { a : String
    , b : String
    }


init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd msg )
init flags url key =
    ( { a = "a"
      , b = "b"
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Ram


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            ( model, Cmd.none )

        UrlChanged url ->
            ( model, Cmd.none )

        Ram ->
            ( { model | b = "c" }, Cmd.none )



---- SUBS ----


subscription : model -> Sub msg
subscription _ =
    Sub.none



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "RanGen"
    , body =
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , div []
            [ text "Render some:"
            , text (model.a ++ " " ++ model.b)
            , button [ onClick Ram ] [ text "click me" ]
            ]
        ]
    }



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscription
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
