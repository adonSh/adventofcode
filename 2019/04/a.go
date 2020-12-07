package main

import (
	"fmt"
	"strconv"
)

func main() {
	low  := 134792
	high := 675810
	count := 0

	for i := low; i <= high; i++ {
		if hasIncreasingDigits(i) && hasRepeat(i) {
			count += 1
		}
	}

	fmt.Println(count)
}

func hasIncreasingDigits(n int) bool {
	var i int
	rv := true
	acc := n % 10

	for i = 10; n % i != n; i *= 10 {
		rv = rv && acc * 10 >= n % i - acc
		acc = n % i
	}

	return rv && acc * 10 >= n % i - acc
}

func hasRepeat(n int) bool {
	s := strconv.Itoa(n)

	for i := 1; i < len(s); i++ {
		if s[i] == s[i - 1] {
			return true
		}
	}

	return false
}
