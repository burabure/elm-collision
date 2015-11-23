import Color
import Graphics.Collage as Collage
import Graphics.Element as Element
import Mouse
import Window
import Collision
import Collision.Hitbox as Hitbox


main : Signal Element.Element
main =
  Signal.map2 scene Mouse.position Window.dimensions


scene : (Int,Int) -> (Int,Int) -> Element.Element
scene (x,y) (w,h) =
  let
    (dx,dy) = -- Translate Mouse coordinates to Collage coordinate space
      (toFloat x - toFloat w / 2, toFloat h / 2 - toFloat y)

    rectangle1Hitbox = -- Create a rectangle hitbox
      Hitbox.rectangle dx dy 60 60

    rectangle2Hitbox = -- Create a rectangle hitbox
      Hitbox.rectangle 0 0 80 80

    rectanglesCollision = -- Test if rectangles are colliding?
      Collision.axisAlignedBoundingBox rectangle1Hitbox rectangle2Hitbox

    rectangleColor = -- If rectangles collide change color
      if rectanglesCollision then Color.red else Color.blue
      
  in
    Collage.collage w h
      [ Collage.rect 80 80
          |> Collage.filled rectangleColor

      , Collage.rect 60 60
          |> Collage.filled Color.orange
          |> Collage.move (dx, dy)

      , message "Collision" rectanglesCollision
      ]


message : String -> a -> Collage.Form
message title stringable =
  title ++ ": " ++ (toString stringable)
  |> Element.show
  |> Collage.toForm
  |> Collage.move (0, 80)
