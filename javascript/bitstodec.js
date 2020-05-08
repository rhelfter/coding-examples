function bits_to_dec(bbits) {
  if(bbits == 0) { return 0; }
  if(bbits == 1) { return 128; }
  if(bbits == 2) { return 192; }
  if(bbits == 3) { return 224; }
  if(bbits == 4) { return 240; }
  if(bbits == 5) { return 248; }
  if(bbits == 6) { return 252; }
  if(bbits == 7) { return 254; }
  if(bbits == 8) { return 255; }
}
