import Color
import Graphics.Collage as Collage
import Graphics.Element as Element
import Mouse
import Window
import Collision2D


main : Signal Element.Element
main =
  Signal.map2 scene Mouse.position Window.dimensions


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
