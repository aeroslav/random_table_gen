module Pages.TablesList exposing (TablesModel)

import Time


type alias TablesModel =
    List TablesListEntry


type alias TablesListEntry =
    { tableSetId : String
    , name : String
    , date : Time.Posix
    , author : String -- author id
    , description : String
    }
