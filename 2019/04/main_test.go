package main

import "testing"

func TestRepeat(t *testing.T) {
	n := 1233987
	if hasRepeat(n) != true {
		t.Errorf("%d has an undetected repeated digit", n)
	}

	n = 1234987
	if hasRepeat(n) == true {
		t.Errorf("%d has a falsely detected repeated digit", n)
	}

	n = 1233488
	if hasRepeat(n) != true {
		t.Errorf("%d has multiple repeated digits but none detected", n)
	}

	n = 1233389
	if hasRepeat(n) == true {
		t.Errorf("%d has a digit repeated more than twice but still passes", n)
	}

	n = 112233
	if hasRepeat(n) != true {
		t.Errorf("%d has digit repeated once but does not pass", n)
	}

	n = 123444
	if hasRepeat(n) == true {
		t.Errorf("%d has a digit repeated more than twice but still passes", n)
	}

	n = 1111122
	if hasRepeat(n) != true {
		t.Errorf("%d has digit repeated once but does not pass", n)
	}

	n = 1235322
	if hasRepeat(n) != true {
		t.Errorf("%d has digit repeated once but does not pass", n)
	}
}

func TestIncreasing(t *testing.T) {
	n := 12345678
	if hasIncreasingDigits(n) != true {
		t.Errorf("%d has increasing digits but the program says otherwise", n)
	}

	n = 222222
	if hasIncreasingDigits(n) != true {
		t.Errorf("%d has increasing digits but the program says otherwise", n)
	}

	n = 12343678
	if hasIncreasingDigits(n) == true {
		t.Errorf("%d succeeds but does not have increasing digits", n)
	}

	n = 32345
	if hasIncreasingDigits(n) == true {
		t.Errorf("%d succeeds but does not have increasing digits", n)
	}
}
