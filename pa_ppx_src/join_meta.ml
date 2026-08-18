(** -syntax camlp5o *)

open Rresult
open Bos
open Fpath

let read_fully ifile =
  OS.File.read ifile

let ( let* ) x f = Rresult.(>>=) x f
;;

let push l x = (l := x :: !l)

let read_ic_fully ?(msg="") ?(channel=stdin) () =
  let fd = Unix.descr_of_in_channel channel in
  if Unix.isatty fd && msg <> "" then begin
    Printf.printf "%s\n" msg ; flush stdout ;
  end ;
  let b = Buffer.create 23 in
  let rec rrec () =
    match try Some(input_char channel)
      with End_of_file -> None with
	None -> Buffer.contents b
      | Some c -> Buffer.add_char b c ; rrec ()
  in
  rrec()

let pkgmap = ref []

let direct_include = ref ""

let wrap_subdirs = ref []

let split2 ~msg s =
  match [%match {|^([^:]+):([^:]+)$|} / strings (!1,!2) dynamic] s with
    Some (name, subdir) -> (name, subdir)
  | _ -> failwith Fmt.(str "%s: invalid arg <<%s>>" msg s)
;;

Arg.(parse [
         "-direct-include", (Arg.Set_string direct_include),
         ("<subdir>    directly include <subdir>/META file")
        ;"-wrap-subdir", (Arg.String (fun s -> push wrap_subdirs (split2 ~msg:"wrap-subdir" s))),
         ("<name>:<subdir>    include <subdir>/META file wrapped as subpackage <name>")
        ;"-rewrite", (Arg.String (fun s -> push pkgmap (split2 ~msg:"rewrite" s))),
         ("<name1>:<name2>    rewrite packages named <name1> to <name2> in `require' statements")
       ]
       (fun _ -> failwith "join_meta: no anonymous args supported")
     "join_meta -destdir <dir>")
;;


let indent n txt =
  let pfx = String.make n ' ' in
  [%subst {|^|} / {|${pfx}|} / g m dynamic] txt

let fix txt =
  let l = [%split {|\s*,\s*|} / dynamic] txt in
  let f s =
    match List.assoc s !pkgmap with
      exception Not_found -> s
    | v -> v in
  let ol =
    l
    |> List.map (fun p ->
           [%subst {|^([^.]+)|} / {| f $1$ |} / e dynamic] p
         ) in
  String.concat "," ol

let fix0 txt =
  [%subst {|"([^"]+)"|} / {| "\"" ^ fix($1$) ^ "\"" |} / e dynamic] txt


let fixdeps txt =
  [%subst {|^(.*require.*)$|} / {| fix0($1$) |} / m g e dynamic] txt

let capturex (cmd, args) =
  let channel = Unix.open_process_args_in cmd args in
  let txt = read_ic_fully ~channel () in
  close_in channel ;
  txt
;;

if !direct_include <> "" then
  print_string (indent 2 (fixdeps(R.failwith_error_msg (read_fully (v [%pattern {|./${!direct_include}/META|}])))))
;;
!wrap_subdirs
|> List.rev
|> List.iter (fun (name, subdir) ->
       let txt = indent 2 (fixdeps(R.failwith_error_msg (read_fully (v [%pattern {|./${subdir}/META|}])))) in
       print_string [%pattern {|
package "${name}" (
${txt}
)
|}]
     )
;;
