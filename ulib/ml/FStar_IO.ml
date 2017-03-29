exception EOF
type fd_read = in_channel
type fd_write = out_channel
type fd_read_bin = in_channel
type fd_write_bin = out_channel
let pr  = Printf.printf
let spr = Printf.sprintf
let fpr = Printf.fprintf

let print_newline = print_newline
let print_string s = pr "%s" s; flush stdout
let print_any s = output_value stdout s; flush stdout
let input_line = read_line
let input_int () = Z.of_int (read_int ())
let input_float = read_float
let open_read_file = open_in
let open_write_file = open_out
let open_read_file_bin = open_in_bin
let open_write_file_bin = open_out_bin
let close_read_file = close_in
let close_write_file = close_out
let read_line fd = try Pervasives.input_line fd with End_of_file -> raise EOF
let read_bytes fd count =
  try
    let buf = Bytes.create count in
    Pervasives.really_input fd buf 0 count;
    buf
  with
  End_of_file -> raise EOF
let read_all_bytes fd = read_bytes fd (Pervasives.in_channel_length fd)
let write_string = output_string
let write_bytes = output_bytes

let debug_print_string s = print_string s; false
