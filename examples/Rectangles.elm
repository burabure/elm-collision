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

    rectangle1Hitbox = -- Create a rectangle hitbox
      Collision2D.rectangle dx dy 60 60

    rectangle2Hitbox = -- Create a rectangle hitbox
      Collision2D.rectangle 0 0 80 80

    rectanglesCollision2D = -- Test if rectangles are colliding?
      Collision2D.axisAlignedBoundingBox rectangle1Hitbox rectangle2Hitbox

    rectangleColor = -- If rectangles collide change color
      if rectanglesCollision2D then Color.red else Color.blue

  in
    Collage.collage w h
      [ Collage.rect 80 80
          |> Collage.filled rectangleColor

      , Collage.rect 60 60
          |> Collage.filled Color.orange
          |> Collage.move (dx, dy)

      , message "Collision2D" rectanglesCollision2D
      ]


message : String -> a -> Collage.Form
message title stringable =
  title ++ ": " ++ (toString stringable)
  |> Element.show
  |> Collage.toForm
  |> Collage.move (0, 80)
