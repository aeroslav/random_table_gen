module Tables exposing (Table, TableEntry, TableSet)


type alias TableSet =
    { id : String
    , name : String
    , tables : List Table
    }


type alias Table =
    { caption : String
    , die : Int
    , entries : List TableEntry
    }


type alias TableEntry =
    { value : String
    , weight : Int
    }
