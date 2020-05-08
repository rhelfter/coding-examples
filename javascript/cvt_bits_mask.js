function cvt_bits_mask(cbits) {
  if (cbits <= 8) {
    var aa = bits_to_dec(cbits);
    var ab = 0;
    var ac = 0;
    var ad = 0;
  } else {
      var aa = 255;
      if (cbits <= 16) {
        var ab = bits_to_dec(cbits-8);
        var ac = 0;
        var ad = 0;
      } else {
        var ab = 255;
        if (cbits <= 24) {
          var ac = bits_to_dec(cbits-16);
          var ad = 0;
        } else {
          var ac = 255;
          if (cbits <= 32) {
            var ad = bits_to_dec(cbits-24);
          }
        }
     }
   }
   var answer = aa + "." + ab + "." + ac + "." + ad;
   return answer; 
}
