module Model.Search.Arguments exposing (Arguments, newArguments)


type alias Arguments =
    { agencyIds : List String
    , routeId : String
    }

newArguments : Arguments
newArguments =
    Arguments [] ""
