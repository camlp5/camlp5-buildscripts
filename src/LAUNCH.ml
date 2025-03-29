
open Rresult
open Bos
open Fpath

let push l x = l := x :: !l

let verbose = ref false
let veryverbose = ref false
let cmd = ref []
let _ =
  Arg.
  (parse
    ["-v", Set verbose, "verbose output";
     "-vv", Set veryverbose, "very verbose output";
     "--", Rest (fun s -> cmd := !cmd @ [s]), "the command"]
    (fun s -> cmd := !cmd @ [s]) "LAUNCH [-v] [--] <cmd>")

let ( let* ) x f = Rresult.(>>=) x f

let exists_directory p = Sys.file_exists p && Sys.is_directory p

let main () =
  let* top =
    match OS.Env.var "TOP" with
      Some v -> Ok v
    | None ->
        Error
          (`Msg
             "LAUNCH: environment variable TOP *must* be set to use this wrapper")
  in
  let ocamlpath_pathsep =
    match Sys.os_type with
      "Unix" -> ":"
    | _ -> ";"
  in
  let path_pathsep =
    match Sys.os_type with
      "Unix" -> ":"
    | _ -> ";"
  in
  let newbindir = String.concat "" [top; "/local-install/bin"] in
  let newlibdir = String.concat "" [top; "/local-install/lib"] in
  let* () =
    if exists_directory newbindir then
      let* path = OS.Env.req_var "PATH" in
      let newpath =
        String.concat "" [newbindir; ""; path_pathsep; ""; path]
      in
      if !veryverbose then
        Fmt.(pf stderr "LAUNCH: PATH=%a\n%!" Dump.string newpath);
      OS.Env.set_var "PATH" (Some newpath)
    else Ok ()
  in
  let* () =
    if exists_directory newlibdir then
      let newcamlpath = String.concat "" [newlibdir; ""; ocamlpath_pathsep] in
      if !veryverbose then
        Fmt.(pf stderr "LAUNCH: OCAMLPATH=%a\n%!" Dump.string newcamlpath);
      OS.Env.set_var "OCAMLPATH" (Some newcamlpath)
    else Ok ()
  in
  match !cmd with
    exe :: _ ->
      let cmd = !cmd in
      let cmd = Filename.quote_command (List.hd cmd) (List.tl cmd) in
      if !verbose || !veryverbose then
        Fmt.(pf stderr "LAUNCH: command %s\n%!" cmd);
      let st = Unix.system cmd in
      begin match st with
        Unix.WEXITED 0 -> Ok ()
      | Unix.WEXITED n -> exit n
      | WSIGNALED n ->
          Error
            (`Msg (Printf.sprintf "LAUNCH: command killed by signal %d" n))
      | WSTOPPED n ->
          Error
            (`Msg (Printf.sprintf "LAUNCH: command stopped by signal %d" n))
      end
  | _ ->
      Error
        (`Msg
           "LAUNCH: at least one argument (the command-name) must be provided")

let _ =
  try R.failwith_error_msg (main ()) with
    exc -> Fmt.(pf stderr "%a\n%!" exn exc); exit 1
