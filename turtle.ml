
open Gg
open Vg

module Graphics = struct
  type t = {
    color: Gg.Color.t;
    path: P.t;
    img: I.t;
    view: Size2.t;
    p: P2.t;
    line_width: float;
    oc: out_channel;
  }

  let empty = {
    color = Gg.Color.black;
    path = P.empty;
    img = I.const Color.void;
    view = Size2.unit;
    p = P2.o;
    line_width = 1.;
    oc = stdout;
  }

  let open_graph oc w h =
    { empty with
      view = Size2.v w h;
      oc = oc;
    }

  let moveto i x y =
    let p = P2.v x y in
    { i with p; path = i.path >> P.sub p }

  let lineto i x y =
    let p = P2.v x y in
    { i with p; path = i.path >> P.line p }

  let flush_path i =
    let area = `O ({P.o with width = i.line_width}) in
    let path_img = I.const i.color >> I.cut ~area i.path in
    { i with img = i.img >> I.blend path_img; path = P.empty >> P.sub i.p }

  let set_color i c =
    let i = flush_path i in
    { i with color = c }

  let set_line_width i d =
    let i = flush_path i in
    { i with line_width = d }

  let svg_of_usquare oc img view_size =
    let size = view_size in
    let view = Box2.v P2.o view_size in
    let dpi30 = let s = 30. /. 0.0254 in Size2.v s s in
    try
      let r = Vgr.create (Vgr_cairo.stored_target (`Png dpi30)) (`Channel oc) in
      try
        ignore (Vgr.render r (`Image (size, view, img)));
        ignore (Vgr.render r `End);
      with e -> close_out oc; raise e
    with Sys_error e -> prerr_endline e

  let close_graph i =
    let i = flush_path i in
    svg_of_usquare i.oc i.img i.view
end

type color = Gg.color
let black = Gg.Color.black
let white = Gg.Color.white
let red = Gg.Color.red
let green = Gg.Color.green
let blue = Gg.Color.blue

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
let img = ref Graphics.empty
let set_color c = img := Graphics.set_color !img c

let forward d =
  tx := !tx +. float d *. A.cos !angle;
  ty := !ty +. float d *. A.sin !angle;
  if !draw then img := lineto !img !tx !ty
           else img := moveto !img !tx !ty

let open_graph oc =
  let i = Graphics.open_graph oc 800. 800. in
  let i = set_line_width i 2. in
  img := moveto i !tx !ty
let close () = Graphics.close_graph !img; img := empty
