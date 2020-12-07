package main

import (
	"bufio"
	"fmt"
	"io"
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

	r, w := io.Pipe()

	intcode.INPUT  = bufio.NewReader(os.Stdin)
	intcode.OUTPUT = bufio.NewWriter(w)

	program, err := intcode.Parse(strings.Trim(string(input), "\n"))
	if err != nil {
		intcode.OUTPUT.WriteString("and i oop")
		os.Exit(1)
	}

	go func() { intcode.Eval(program); w.Close(); }()

	scanner := bufio.NewScanner(r)

	count := 0
	for i := 0; scanner.Scan(); i++ {
		if i % 3 == 2 && scanner.Text() == "2" {
			count += 1
		}
	}

	fmt.Println(count)
}
