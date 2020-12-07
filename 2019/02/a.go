package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"

	"../intcode"
)

func main() {
	if len(os.Args) < 2 {
		os.Exit(1)
	}

	input, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		os.Exit(1)
	}

	program, err := intcode.Parse(strings.Trim(string(input), "\n"))
	if err != nil {
		fmt.Fprintln(os.Stderr, "Invalid Input")
		os.Exit(1)
	}

	program[1] = 12
	program[2] = 2
	intcode.Eval(program)
	fmt.Println(program[0])

	output := strconv.Itoa(program[0])
	for i := 1; i < len(program); i ++ {
		output += "," + strconv.Itoa(program[i])
	}
	output += "\n"
	ioutil.WriteFile("output", []byte(output), 0644)
}
