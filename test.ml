open Turtle

let rec l n = begin
  if n > 0 then begin
    turn_right 90;
    r (n-1);
    set_color red;
    forward 8;
    turn_left 90;
    l (n-1);
    forward 8;
    l (n-1);
    turn_left 90;
    forward 8;
    r (n-1);
    turn_right 90;
  end
end
and r n = begin
  if n > 0 then begin
    turn_left 90;
    l (n-1);
    set_color blue;
    forward 8;
    turn_right 90;
    r (n-1);
    forward 8;
    r (n-1);
    turn_right 90;
    forward 8;
    l (n-1);
    turn_left 90;
  end
end

let () = begin
  Turtle.open_graph stdout;
  set_color red;
  pen_up ();
  forward (-250);
  turn_left 90;
  forward (-250);
  pen_down ();
  l 6;
  Turtle.close ();
end