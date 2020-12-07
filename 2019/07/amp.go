package main

import (
	"bufio"
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

	intcode.INPUT  = bufio.NewReader(os.Stdin)
	intcode.OUTPUT = os.Stdout

	program, err := intcode.Parse(strings.Trim(string(input), "\n"))
	if err != nil {
		intcode.OUTPUT.WriteString("and i oop")
		os.Exit(1)
	}

	intcode.Eval(program)
}
