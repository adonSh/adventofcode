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

	findProgram(program, 19690720)
	fmt.Println(100 * program[1] + program[2])

	output := strconv.Itoa(program[0])
	for i := 1; i < len(program); i ++ {
		output += "," + strconv.Itoa(program[i])
	}
	output += "\n"
	ioutil.WriteFile("output", []byte(output), 0644)
}

func findProgram(program []int, val int) {
	cpy := make([]int, len(program))
	for i := 0; i < 100; i++ {
		for j := 0; j < 100; j++ {
			copy(cpy, program)
			cpy[1] = i
			cpy[2] = j
			intcode.Eval(cpy)
			if cpy[0] == val {
				program[1] = i
				program[2] = j
				intcode.Eval(program)
				return
			}
		}
	}
}
