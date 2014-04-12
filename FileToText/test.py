def pass2Hash(password):
	shift = 0
	t = 0
	hash = []
	for char in password:
		currentByte = int(char, 16) 
		currentByte = currentByte << shift
		shift += 5
		t = t | currentByte
		if shift >= 8:
			#let's write this shit right over here
			hash.append(hex(t & 0xFF))
			t = t >> 8 #(delete rightmost byte)
			shift -= 8
	return hash
				
print(pass2Hash('deadbeef1234554321'))