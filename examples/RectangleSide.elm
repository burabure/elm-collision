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

    rectangle1Hitbox = -- Create a rectangle hitbox
      Collision2D.rectangle dx dy 60 60

    rectangle2Hitbox = -- Create a rectangle hitbox
      Collision2D.rectangle 0 0 80 80

    rectanglesCollision2D = -- Which side of rectangle1 is colliding?
      Collision2D.rectangleSide rectangle1Hitbox rectangle2Hitbox

    rectangleColor = -- If rectangles collide change color
      if rectanglesCollision2D /= Nothing then Color.red else Color.blue

  in
    Collage.collage w h
      [ Collage.rect 80 80
          |> Collage.filled rectangleColor

      , Collage.rect 60 60
          |> Collage.filled Color.orange
          |> Collage.move (dx, dy)

      , message "Side" rectanglesCollision2D
          |> Collage.move (dx, dy + 10)
      ]


message : String -> a -> Collage.Form
message title stringable =
  title ++ ": " ++ (toString stringable)
  |> Element.show
  |> Collage.toForm


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
