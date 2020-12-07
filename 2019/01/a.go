package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	if len(os.Args) < 2 {
		os.Exit(1)
	}

	input, err := os.Open(os.Args[1])
	if err != nil {
		os.Exit(1)
	}
	scanner := bufio.NewScanner(input)
	sum := 0

	for scanner.Scan() {
		mass, err := strconv.Atoi(scanner.Text())
		if err != nil {
			os.Exit(1)
		}
		sum += fuel_required(mass)
	}

	fmt.Println(sum)
}

func fuel_required(mass int) int {
	return (mass / 3) - 2
}
