function do_subtract(s_ip) {
  var split_ip = s_ip.split(".");
  var a = 255-split_ip[0];
  var b = 255-split_ip[1];
  var c = 255-split_ip[2];
  var d = 255-split_ip[3];
  var answer = a + "." + b + "." + c + "." + d;
  return answer;
}
