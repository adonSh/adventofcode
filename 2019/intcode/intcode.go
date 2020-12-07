package intcode

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Op struct {
	Op       int
	Num_args int
	Pmodes   []int
}

var INPUT  *bufio.Reader
var OUTPUT *bufio.Writer

func addOrMult(op *Op, program []int, pointer int, rb int) []int {
	a := 0
	if op.Pmodes[0] == 2 {
		if program[pointer + 1] + rb < len(program) {
			a = program[program[pointer + 1] + rb]
		}
	} else if op.Pmodes[0] == 1 {
		if pointer + 1 < len(program) {
			a = program[pointer + 1]
		}
	} else if op.Pmodes[0] == 0 {
		if program[pointer + 1] < len(program) {
			a = program[program[pointer + 1]]
		}
	}

	b := 0
	if op.Pmodes[1] == 2 {
		if program[pointer + 2] + rb < len(program) {
			b = program[program[pointer + 2] + rb]
		}
	} else if op.Pmodes[1] == 1 {
		if pointer + 2 < len(program) {
			b = program[pointer + 2]
		}
	} else if op.Pmodes[1] == 0 {
		if program[pointer + 2] < len(program) {
			b = program[program[pointer + 2]]
		}
	}

	dst := program[pointer + 3]
	if op.Pmodes[2] == 0 || op.Pmodes[2] == 1 {
		if program[pointer + 3] >= len(program) {
			for i := len(program); i <= program[pointer + 3]; i++ {
				program = append(program, 0)
			}
		}
	} else if op.Pmodes[2] == 2 {
		if program[pointer + 3] + rb >= len(program) {
			for i := len(program); i <= program[pointer + 3] + rb; i++ {
				program = append(program, 0)
			}
		}
		dst = program[pointer + 3] + rb
	}

	if op.Op == 1 {
		program[dst] = a + b
	} else if op.Op == 2 {
		program[dst] = a * b
	}

	return program
}

func jump(op *Op, program []int, pointer int, rb int) ([]int, int) {
	a := 0
	if op.Pmodes[0] == 2 {
		if program[pointer + 1] + rb < len(program) {
			a = program[program[pointer + 1] + rb]
		}
	} else if op.Pmodes[0] == 1 {
		if pointer + 1 < len(program) {
			a = program[pointer + 1]
		}
	} else if op.Pmodes[0] == 0 {
		if program[pointer + 1] < len(program) {
			a = program[program[pointer + 1]]
		}
	}

	dst := program[pointer + 2]
	if op.Pmodes[1] == 2 {
		if program[pointer + 2] + rb >= len(program) {
			for i := len(program); i <= program[pointer + 2]; i++ {
				program = append(program, 0)
			}
		}
		dst = program[program[pointer + 2] + rb]
	} else if op.Pmodes[1] == 1 {
		if pointer + 2 >= len(program) {
			for i := len(program); i <= program[pointer + 2]; i++ {
				program = append(program, 0)
			}
		}
	} else if op.Pmodes[1] == 0 {
		if program[pointer + 2] >= len(program) {
			for i := len(program); i <= program[pointer + 2]; i++ {
				program = append(program, 0)
			}
		}
		dst = program[program[pointer + 2]]
	}

	if op.Op == 5 && a != 0 {
		return program, dst
	} else if op.Op == 6 && a == 0 {
		return program, dst
	}

	return program, pointer + op.Num_args + 1
}

func compare(op *Op, program []int, pointer int, rb int) []int {
	a := 0
	if op.Pmodes[0] == 2 {
		if program[pointer + 1] + rb < len(program) {
			a = program[program[pointer + 1] + rb]
		}
	} else if op.Pmodes[0] == 1 {
		if pointer + 1 < len(program) {
			a = program[pointer + 1]
		}
	} else if op.Pmodes[0] == 0 {
		if program[pointer + 1] < len(program) {
			a = program[program[pointer + 1]]
		}
	}

	b := 0
	if op.Pmodes[1] == 2 {
		if program[pointer + 2] + rb < len(program) {
			b = program[program[pointer + 2] + rb]
		}
	} else if op.Pmodes[1] == 1 {
		if pointer + 2 < len(program) {
			b = program[pointer + 2]
		}
	} else if op.Pmodes[1] == 0 {
		if program[pointer + 2] < len(program) {
			b = program[program[pointer + 2]]
		}
	}

	dst := program[pointer + 3]
	if op.Pmodes[2] == 0 || op.Pmodes[2] == 1 {
		if program[pointer + 3] >= len(program) {
			for i := len(program); i <= program[pointer + 3]; i++ {
				program = append(program, 0)
			}
		}
	} else if op.Pmodes[2] == 2 {
		if program[pointer + 3] + rb >= len(program) {
			for i := len(program); i <= program[pointer + 3] + rb; i++ {
				program = append(program, 0)
			}
		}
		dst = program[pointer + 3] + rb
	}

	if op.Op == 7 && a < b {
		program[dst] = 1
	} else if op.Op == 8 && a == b {
		program[dst] = 1
	} else {
		program[dst] = 0
	}

	return program
}

func read(op *Op, program []int, pointer int, rb int) []int {
	input, err := INPUT.ReadString('\n')
	if err != nil {
		fmt.Fprintln(os.Stderr, err.Error())
		return program
	}
	val, err := strconv.Atoi(strings.Trim(input, "\n"))
	if err != nil {
		fmt.Fprintln(os.Stderr, err.Error())
		return program
	}

	dst := program[pointer + 1]
	if op.Pmodes[0] == 0 || op.Pmodes[0] == 1 {
		if program[pointer + 1] >= len(program) {
			for i := len(program); i <= program[i + 1]; i++ {
				program = append(program, 0)
			}
		}
	} else if op.Pmodes[0] == 2 {
		if program[pointer + 1] + rb >= len(program) {
			for i := len(program); i <= program[i + 1] + rb; i++ {
				program = append(program, 0)
			}
		}
		dst = program[pointer + 1] + rb
	}

	program[dst] = val
	return program
}

func write(op *Op, program []int, pointer int, rb int) []int {
	val := "0"

	if op.Pmodes[0] == 2 {
		if program[pointer + 1] + rb < len(program) {
			val = strconv.Itoa(program[program[pointer + 1] + rb])
		}
	} else if op.Pmodes[0] == 1 {
		if pointer + 1 < len(program) {
			val = strconv.Itoa(program[pointer + 1])
		}
	} else if op.Pmodes[0] == 0 {
		if program[pointer + 1] < len(program) {
			val = strconv.Itoa(program[program[pointer + 1]])
		}
	}

	fmt.Fprintln(OUTPUT, val)
	OUTPUT.Flush()
	return program
}

func rb_inc(op *Op, program []int, pointer int, rb int) ([]int, int) {
	inc := 0

	if op.Pmodes[0] == 2 {
		if program[pointer + 1] + rb < len(program) {
			inc = program[program[pointer + 1] + rb]
		}
	} else if op.Pmodes[0] == 1 {
		if pointer + 1 < len(program) {
			inc = program[pointer + 1]
		}
	} else if op.Pmodes[0] == 0 {
		if program[pointer + 1] < len(program) {
			inc = program[program[pointer + 1]]
		}
	}

	return program, rb + inc
}

func Eval(program []int) []int {
	i := 0
	rbase := 0

	for i < len(program) {
		op := Opcode(program[i])
		switch op.Op {
		case 1:
			program = addOrMult(op, program, i, rbase)
			i += 1 + op.Num_args
		case 2:
			program = addOrMult(op, program, i, rbase)
			i += 1 + op.Num_args
		case 3:
			program = read(op, program, i, rbase)
			i += 1 + op.Num_args
		case 4:
			program = write(op, program, i, rbase)
			i += 1 + op.Num_args
		case 5:
			program, i = jump(op, program, i, rbase)
		case 6:
			program, i = jump(op, program, i, rbase)
		case 7:
			program = compare(op, program, i, rbase)
			i += 1 + op.Num_args
		case 8:
			program = compare(op, program, i, rbase)
			i += 1 + op.Num_args
		case 9:
			program, rbase = rb_inc(op, program, i, rbase)
			i += 1 + op.Num_args
		case 99:
			return program
		}
	}

	return program
}

func Tokenize(prgrm string) []string {
	return strings.Split(prgrm, ",")
}

func Parse(pre string) ([]int, error) {
	var post []int
	tokens := Tokenize(pre)

	for i := 0; i < len(tokens); i++ {
		token, err := strconv.Atoi(tokens[i])
		if err != nil {
			return nil, err
		}
		post = append(post, token)
	}

	return post, nil
}

func Opcode(n int) *Op {
	op    := new(Op)
	modes := n / 100
	op.Op  = n % 100

	switch op.Op {
	case 1:
		op.Num_args = 3
	case 2:
		op.Num_args = 3
	case 3:
		op.Num_args = 1
	case 4:
		op.Num_args = 1
	case 5:
		op.Num_args = 2
	case 6:
		op.Num_args = 2
	case 7:
		op.Num_args = 3
	case 8:
		op.Num_args = 3
	case 9:
		op.Num_args = 1
	case 99:
		op.Num_args = 0
	}

	for i := 0; i < op.Num_args; i++ {
		op.Pmodes = append(op.Pmodes, modes % 10)
		modes /= 10
	}

	return op
}
