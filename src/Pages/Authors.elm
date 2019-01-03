module Pages.Authors exposing (AuthorsModel)


type alias AuthorsModel =
    List
        { id : String
        , name : String
        }
