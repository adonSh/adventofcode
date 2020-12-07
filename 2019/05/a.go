package main

import (
	"io/ioutil"
	"os"
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
		os.Exit(1)
	}

	intcode.INPUT  = os.Stdin
	intcode.OUTPUT = os.Stdout

	intcode.Eval(program)
}
