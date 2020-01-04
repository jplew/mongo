open MongoUtils;;

let send_no_reply d request_str =
  let out_ch = Unix.out_channel_of_descr d in
  output_string out_ch request_str;
  flush out_ch;;



(* read complete reply portion, include complete message header *)
let read_reply in_ch =
  let len_str = really_input_string in_ch 4 in
  let (len32, _) = decode_int32 len_str 0 in
  let len = Int32.to_int len32 in
  (*print_endline (Int32.to_string len32);*)
  let str = really_input_string in_ch (len-4) in
  let buf = Buffer.create len in
  Buffer.add_string buf len_str;
  Buffer.add_string buf str;
  Buffer.contents buf;;

let send_with_reply d request_str =
  send_no_reply d request_str;
  let in_ch = Unix.in_channel_of_descr d in
  MongoReply.decode_reply (read_reply in_ch);;
