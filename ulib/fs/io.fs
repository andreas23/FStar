module FStar.IO
exception EOF
open System
open System.IO
type fd_read      = TextReader
type fd_write     = TextWriter
type fd_read_bin  = BinaryReader
type fd_write_bin = BinaryWriter

let print_newline _ = Printf.printf "\n"
let print_string x   = Printf.printf "%s" x
let print_any x      = Printf.printf "%A" x
let input_line ()    = System.Console.ReadLine()
let input_int  ()    = Int32.Parse(System.Console.ReadLine())
let input_float ()   = Single.Parse(System.Console.ReadLine(), System.Globalization.CultureInfo.InvariantCulture);
let open_read_file (x:string)  = new StreamReader(x)
let open_write_file (x:string) = File.CreateText(x)
let open_read_file_bin (x:string)  =
  new BinaryReader(File.Open(x, FileMode.Open, FileAccess.Read))
let open_write_file_bin (x:string) = File.CreateText(x)
  new BinaryReader(File.Open(x, FileMode.Create, FileAccess.Write))
let close_read_file (x:fd_read)   = x.Close()
let close_write_file (x:fd_write) = x.Close()
let read_line (fd:fd_read)     =
    let x = fd.ReadLine() in
    if x=null
    then raise EOF
    else x
let write_string (fd:fd_write) (x:string) =
    fd.Write(x)
