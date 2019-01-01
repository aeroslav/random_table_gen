module Main exposing (Model, init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Canopy as T exposing (Node)
import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Html.Events exposing (onClick)
import Http
import Types exposing (..)
import Url



---- MODEL ----


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , page : PageModel
    , text : String
    }


init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd msg )
init flags url key =
    ( getModel key url, Cmd.none )


getModel : Nav.Key -> Url.Url -> Model
getModel key url =
    Model key url NotFound ""



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External str ->
                    ( model, Nav.load str )

        UrlChanged url ->
            ( { model | url = url }, Cmd.none )

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

        NoOp ->
            ( model, Cmd.none )



---- SUBS ----


subscription : Model -> Sub msg
subscription _ =
    Sub.none



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "RanGen"
    , body =
        [ div [ class "wrapper columns" ]
            [ asideMenu
            , main_ [ class "column col-10" ]
                [ div []
                    [ span [ onClick Request ] [ text "Send!" ]
                    , p [] [ text model.text ]
                    ]
                ]
            ]
        ]
    }


asideMenu : Html msg
asideMenu =
    aside [ class "column col-2 bg-secondary" ]
        [ div [ class "logo" ] [ img [ src "/logo.svg" ] [] ]
        , ul [ class "nav" ]
            [ menuLink "Explore" (Just "/explore")
            , ul [ class "nav" ]
                [ menuLink "Tables" (Just "/tables")
                , menuLink "Tags" (Just "/tags")
                , menuLink "Authors" (Just "/authors")
                ]
            , menuLink "Create" (Just "/create")
            , menuLink "Profile" (Just "/profile")
            ]
        ]


menuLink : String -> Maybe String -> Html msg
menuLink label link =
    let
        linkAttrs =
            case link of
                Just str ->
                    [ href str ]

                Nothing ->
                    []
    in
    li [ class "nav-item" ]
        [ a linkAttrs [ text label ] ]



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
