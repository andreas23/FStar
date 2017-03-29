module FStar.IO

open FStar.All

exception EOF
assume new type fd_read : Type0
assume new type fd_write : Type0

val print_newline : unit -> ML unit
val print_string : string -> ML unit
val print_any : 'a -> ML unit
val input_line : unit -> ML string
val input_int : unit -> ML int
val input_float : unit -> ML FStar.Float.float
val open_read_file : string -> ML fd_read
val open_write_file : string -> ML fd_write
val open_read_file_bin : string -> ML fd_read
val open_write_file_bin : string -> ML fd_write
val close_read_file : fd_read -> ML unit
val close_write_file : fd_write -> ML unit
val read_line : fd_read -> ML string
val read_bytes : fd_read -> int -> ML FStar.Bytes.bytes
val read_all_bytes : fd_read -> ML FStar.Bytes.bytes
val write_string : fd_write -> string -> ML unit
val write_bytes : fd_write -> FStar.Bytes.bytes -> ML unit

(*
   An UNSOUND escape hatch for printf-debugging;
   Although it always returns false, we mark it
   as returning a bool, so that extraction doesn't
   erase this call.

   Note: no guarantees are provided regarding the order
   of evaluation of this function; since it is marked as pure,
   the compiler may re-order or replicate it.
*)
val debug_print_string : string -> Tot bool
