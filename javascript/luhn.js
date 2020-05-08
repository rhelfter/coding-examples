<script>
  Benchmark.prototype.setup = function() {
    var ccNum = "4984421209470251";
    
    function luhnChk(luhn) {
        var len = luhn.length,
            mul = 0,
            prodArr = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]],
            sum = 0;
    
        while (len--) {
            sum += prodArr[mul][parseInt(luhn.charAt(len), 10)];
            mul ^= 1;
        }
        return sum % 10 === 0 && sum > 0;
    };
    
    
        function is_valid_luhn(number) {
          var digit, n, sum, _len, _ref;
          sum = 0;
          _ref = number.split('').reverse().join('');
          for (n = 0, _len = _ref.length; n < _len; n++) {
            digit = _ref[n];
            digit = +digit;
            if (n % 2) {
              digit *= 2;
              if (digit < 10) {
                sum += digit;
              } else {
                sum += digit - 9;
              }
            } else {
              sum += digit;
            }
          }
          return sum % 10 === 0;
        };
    
    // Luhn algorithm validator
    function luhnCheckFast(luhn)
    {                                  
        var ca, sum = 0, mul = 0;
        var len = luhn.length;
        while (len--)
        {
            ca = parseInt(luhn.charAt(len),10) << mul;
            sum += ca - (ca>9)*9; // sum += ca - (-(ca>9))|9
            // 1 <--> 0 toggle.
            mul ^= 1; // mul = 1 - mul;
        };
        return (sum%10 === 0) && (sum > 0);
    };
    
    function luhnCheckFast2(luhn)
    {
        var ca, sum = 0, mul = 1;
        var len = luhn.length;
        while (len--)
        {
            ca = parseInt(luhn.charAt(len),10) * mul;
            sum += ca - (ca>9)*9;// sum += ca - (-(ca>9))|9
            // 1 <--> 2 toggle.
            mul ^= 3; // (mul = 3 - mul);
        };
        return (sum%10 === 0) && (sum > 0);
    };
    
    
    function isCreditCard(CC) {
      if (CC.length > 19) return (false);
    
      sum = 0;
      mul = 1;
      l = CC.length;
      for (i = 0; i < l; i++) {
        digit = CC.substring(l - i - 1, l - i);
        tproduct = parseInt(digit, 10) * mul;
        if (tproduct >= 10) sum += (tproduct % 10) + 1;
        else sum += tproduct;
        if (mul == 1) mul++;
        else mul--;
      }
      if ((sum % 10) == 0) return (true);
      else return (false);
    }
    
    
    // http://imei.sms.eu.sk/
    // Javascript code copyright 2009 by Fiach Reid : www.webtropy.com
    // This code may be used freely, as long as this copyright notice is intact.
    
    
    function Calculate(Luhn) {
      var sum = 0;
      for (i = 0; i < Luhn.length; i++) {
        sum += parseInt(Luhn.substring(i, i + 1));
      }
      var delta = new Array(0, 1, 2, 3, 4, -4, -3, -2, -1, 0);
      for (i = Luhn.length - 1; i >= 0; i -= 2) {
        var deltaIndex = parseInt(Luhn.substring(i, i + 1));
        var deltaValue = delta[deltaIndex];
        sum += deltaValue;
      }
      var mod10 = sum % 10;
      mod10 = 10 - mod10;
      if (mod10 == 10) {
        mod10 = 0;
      }
      return mod10;
    }
    
    function Validate(Luhn) {
      var LuhnDigit = parseInt(Luhn.substring(Luhn.length - 1, Luhn.length));
      var LuhnLess = Luhn.substring(0, Luhn.length - 1);
      if (Calculate(LuhnLess) == parseInt(LuhnDigit)) {
        return true;
      }
      return false;
    }
    
    function checkCC(s) {
      var i, n, c, r, t;
      // First, reverse the string and remove any non-numeric characters.
      r = "";
      for (i = 0; i < s.length; i++) {
        c = parseInt(s.charAt(i), 10);
        if (c >= 0 && c <= 9)
        r = c + r;
      }
      // Check for a bad string.
      if (r.length <= 1)
      return false;
      // Now run through each single digit to create a new string. Even digits
      // are multiplied by two, odd digits are left alone.
      t = "";
      for (i = 0; i < r.length; i++) {
        c = parseInt(r.charAt(i), 10);
        if (i % 2 != 0)
        c *= 2;
        t = t + c;
      }
      // Finally, add up all the single digits in this string.
    
      n = 0;
      for (i = 0; i < t.length; i++) {
        c = parseInt(t.charAt(i), 10);
        n = n + c;
      }
      // If the resulting sum is an even multiple of ten (but not zero), the
      // card number is good.
      if (n != 0 && n % 10 == 0)
      return true;
      else return false;
    }
  };
</script>

function valid_credit_card(value) {
	if (/[^0-9-\s]+/.test(value)) return false;
	var nCheck = 0, nDigit = 0, bEven = false;
	value = value.replace(/\D/g, "");
	for (var n = value.length - 1; n >= 0; n--) {
		var cDigit = value.charAt(n),
			  nDigit = parseInt(cDigit, 10);
		if (bEven) {
			if ((nDigit *= 2) > 9) nDigit -= 9;
		}
		nCheck += nDigit;
		bEven = !bEven;
	}
	return (nCheck % 10) == 0;
}
