module Types exposing (Msg(..), PageModel(..), Role(..))

import Browser
import Http
import Url


type Role
    = Visitor
    | User
    | Admin


type PageModel
    = Tables
    | Tags
    | Authors
    | NewTable
    | NotFound


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Request
    | Response (Result Http.Error String)
    | NoOp
