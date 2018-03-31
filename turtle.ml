
open Gg
open Vg

module Graphics = struct
  let cur_color = ref Gg.Color.black
  let path = ref P.empty
  let img = ref (I.const Color.void)
  let view_size = ref Size2.unit
  let v = ref P2.o
  let line_width = ref 1.

  let open_graph w h = view_size := Size2.v w h

  let moveto x y =
    v := P2.v x y;
    path := !path >> P.sub !v

  let lineto x y =
    v := P2.v x y;
    path := !path >> P.line !v

  let flush_path () =
    let area = `O ({P.o with width = !line_width}) in
    let path_img = I.const !cur_color >> I.cut ~area !path in
    begin
      img := !img >> I.blend path_img;
      path := P.empty >> P.sub !v
    end

  let set_color c =
    flush_path ();
    cur_color := c

  let set_line_width d =
    flush_path ();
    line_width := d

  let svg_of_usquare oc i =
    let size = !view_size in
    let view = Box2.v P2.o !view_size in
    let dpi30 = let s = 30. /. 0.0254 in Size2.v s s in
    try
      let r = Vgr.create (Vgr_cairo.stored_target (`Png dpi30)) (`Channel oc) in
      try
        ignore (Vgr.render r (`Image (size, view, i)));
        ignore (Vgr.render r `End);
      with e -> close_out oc; raise e
    with Sys_error e -> prerr_endline e

  let close_graph oc =
    flush_path (); svg_of_usquare oc !img
end

type color = Gg.color
let black = Gg.Color.black
let white = Gg.Color.white
let red = Gg.Color.red
let green = Gg.Color.green
let blue = Gg.Color.blue
let set_color = Graphics.set_color

module A = struct
  type t = float
  let add = (+.)
  let pi_over_180 = atan 1. /. 45.
  let of_degrees d = d *. pi_over_180
  let cos = Pervasives.cos
  let sin = Pervasives.sin
end

let draw = ref true
let pen_down () = draw := true
let pen_up   () = draw := false

let angle = ref (A.of_degrees 0.)
let turn_left d = angle := A.add !angle (A.of_degrees (float d))
let turn_right d = turn_left (- d)

open Graphics
let tx = ref 400.
let ty = ref 400.
let () = open_graph 800. 800.; set_line_width 2.;
  moveto !tx !ty

let forward d =
  tx := !tx +. float d *. A.cos !angle;
  ty := !ty +. float d *. A.sin !angle;
  if !draw then lineto !tx !ty
           else moveto !tx !ty

let write = Graphics.close_graph
