(** -syntax camlp5o *)

let push l x = (l := x :: !l)

open Rresult
open Bos

let read_fully ifile =
  OS.File.read ifile

let write_fully ~mode ofile txt =
  OS.File.write ~mode ofile txt

let ( let* ) x f = Rresult.(>>=) x f
;;

let verbose = ref true ;;
let files = ref [] ;;

Arg.(parse [
         "-s", (Arg.Clear verbose),
         ("silence verbosity")
       ]
       (fun s -> push files s)
     "fixin [-s] <files>")
;;

let search_path = 
  let dirs = String.split_on_char ':' (Sys.getenv "PATH") in
  List.map Fpath.v dirs

let fix_interpreter ~f (exedir, exename) =
  let open Fpath in
  let exename = v exename in
  let candidates = List.map (fun dir -> append dir exename) search_path in
  match List.find_opt OS.File.is_executable candidates with
    None ->
     if !verbose then Fmt.(pf stderr "Can't find %a in PATH, %a unchanged\n%!" pp exename pp f) ;
     to_string (append (v exedir) exename)
  | Some v ->
     if !verbose then Fmt.(pf stderr "Changing %a to %a\n%!" pp f pp v) ;
     to_string v

let fixin_contents ~f txt =
  let txt = [%subst {|^#!([\S]+/)?([\S]+)|} / {|"#!" ^ (fix_interpreter ~f ($1$, $2$))|} /s e dynamic] txt in
  Ok txt

let fixin1 f =
  let open Fpath in
  let f = v f in
  let newf = add_ext "NEW" f in
  let bakf = add_ext "bak" f in
  let* st = OS.Path.stat f in
  let mode = st.Unix.st_perm in
  let* contents = read_fully f in
  let* contents = fixin_contents ~f contents in
  let* () = write_fully ~mode newf contents in
  let* () = OS.Path.move ~force:true f bakf in
  let* () = OS.Path.move ~force:true newf f in
  Ok ()
;;

!files
|> List.iter (fun f ->
       fixin1 f |> R.failwith_error_msg
     )
;;
