module Update exposing ()

type Msg
    = SetLocation

update : Model -> Msg -> (Model, Msg)
update model msg =
    SetLocation
