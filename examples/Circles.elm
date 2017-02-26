import Color
import Collage
import Element
import Mouse
import Collision2D
import Window exposing (Size)
import Html exposing (..)
import Task


type alias Model =
 { x : Int
 , y : Int
 , size: Size
 }


initialModel: Model
initialModel =
  { x = 0
  , y = 0
  , size = Size 0 0
  }


init : (Model, Cmd Msg)
init =
  (initialModel, Task.perform Resize Window.size)

type Msg
  = Position Int Int
  | Resize Size


update: Msg -> Model -> Model
update msg model =
  case msg of
    Position x y ->
        { model | x = x, y = y }
    Resize size ->
        { model | size = size }


view: Model -> Html a
view model =
  Element.toHtml <|
      scene (model.x, model.y) (model.size.width, model.size.height)


scene : (Int,Int) -> (Int,Int) -> Element.Element
scene (x,y) (w,h) =
  let
    (dx,dy) = -- Translate Mouse coordinates to Collage coordinate space
      (toFloat x - toFloat w / 2, toFloat h / 2 - toFloat y)

    circle1Hitbox = -- Create a circular hitbox
      Collision2D.circle dx dy 30

    circle2Hitbox = -- Create a circular hitbox
      Collision2D.circle 0 0 40

    circlesCollision2D = -- Test if circles are colliding
      Collision2D.circleToCircle circle1Hitbox circle2Hitbox

    circleColor = -- If circles collide change color
      if circlesCollision2D then Color.red else Color.blue

  in
    Collage.collage w h
      [ Collage.circle 40
          |> Collage.filled circleColor

      , Collage.circle 30
          |> Collage.filled Color.orange
          |> Collage.move (dx, dy)

      , message "Collision2D" circlesCollision2D
      ]


message : String -> a -> Collage.Form
message title stringable =
  title ++ ": " ++ (toString stringable)
  |> Element.show
  |> Collage.toForm
  |> Collage.move (0, 80)


main =
  Html.program
    { init = init
    , update = \msg m -> update msg m ! []
    , view = view
    , subscriptions =
      (\_ -> Sub.batch
        [ Window.resizes Resize
        , Mouse.moves (\{x, y} -> Position x y)
        ])
    }
