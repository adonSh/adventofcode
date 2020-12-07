package intcode

import (
	"bufio"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"testing"
)

func (a *Op) Equals(b *Op) bool {
	same_modes := true

	for i := 0; i < len(a.Pmodes); i++ {
		same_modes = same_modes && a.Pmodes[i] == b.Pmodes[i]
	}

	return a.Op == b.Op && a.Num_args == b.Num_args && same_modes
}

func intcodeEquals(a []int, b []int) bool {
	if len(a) != len(b) {
		return false
	}

	for i := 0; i < len(a); i++ {
		if a[i] != b[i] {
			return false
		}
	}

	return true
}

func TestTokenize(t *testing.T) {
	pre := "1,0,0,0,99"
	wanted := []string{ "1", "0", "0", "0", "99" }
	got := Tokenize(pre)

	if len(wanted) != len(got) {
		t.Errorf("Wanted %v, but got %v instead", wanted, got)
	}

	for i := 0; i <len(got); i++ {
		if wanted[i] != got[i] {
			t.Errorf("Wanted %v, but got %v instead", wanted, got)
			break
		}
	}
}

func TestParse(t *testing.T) {
	pre := "1,0,0,0,99"
	wanted := []int{ 1, 0, 0, 0, 99 }
	got, err := Parse(pre)

	if err != nil {
		t.Fatal("Parsing produced an error")
	}

	if !intcodeEquals(wanted, got) {
		t.Errorf("Wanted %v, but got %v instead", wanted, got)
	}
}

func TestHalt(t *testing.T) {
	program := []int{ 99, 1, 1, 1, 0, 99 }
	wanted := []int{ 99, 1, 1, 1, 0, 99 }
	Eval(program)

	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted %d, but got %d instead", wanted, program)
	}
}

func TestPrograms(t *testing.T) {
	program := []int{ 1, 0, 0, 0, 99 }
	wanted := []int{ 2, 0, 0, 0, 99 }
	Eval(program)

	if !intcodeEquals(wanted, program) {
		t.Errorf("Wanted %d, but got %d instead", wanted, program)
	}

	program = []int{ 2, 3, 0, 3, 99}
	wanted = []int{ 2, 3, 0, 6, 99 }
	Eval(program)

	if !intcodeEquals(wanted, program) {
		t.Errorf("Wanted %d, but got %d instead", wanted, program)
	}

	program = []int{ 2, 4, 4, 5, 99, 0 }
	wanted = []int{ 2, 4, 4, 5, 99, 9801 }
	Eval(program)

	if !intcodeEquals(wanted, program) {
		t.Errorf("Wanted %d, but got %d instead", wanted, program)
	}

	program = []int{ 1, 1, 1, 4, 99, 5, 6, 0, 99 }
	wanted = []int{ 30, 1, 1, 4, 2, 5, 6, 0, 99 }
	Eval(program)

	if !intcodeEquals(wanted, program) {
		t.Errorf("Wanted %d, but got %d instead", wanted, program)
	}
}

func TestInput(t *testing.T) {
	ifile, _ := os.Open("itest")
	INPUT = bufio.NewReader(ifile)
	program := []int{ 3, 0, 99 }
	f, err := ioutil.ReadFile("itest")
	if err != nil {
		t.Fatal(err)
	}
	r, err := strconv.Atoi(strings.Trim(string(f), "\n"))
	if err != nil {
		t.Fatal(err)
	}
	wanted := []int{ r, 0, 99 }

	Eval(program)
	if !intcodeEquals(wanted, program) {
		t.Errorf("Wanted %d, but got %d instead", wanted, program)
	}
}

func TestOutput(t *testing.T) {
	o, err := os.OpenFile("otest", os.O_WRONLY, 0644)
	if err != nil {
		t.Fatal(err)
	}
	OUTPUT = bufio.NewWriter(o)
	program := []int{ 4, 0, 99 }

	Eval(program)
	f, err := ioutil.ReadFile("otest")
	if err != nil {
		t.Fatal(err)
	}
	r := strings.Trim(string(f), "\n")

	if r != strconv.Itoa(program[0]) {
		t.Errorf("Wanted %d, but got %s instead", program[0], r)
	}
}

func TestEcho(t *testing.T) {
	ifile, _ := os.Open("itest")
	INPUT = bufio.NewReader(ifile)
	f, err := ioutil.ReadFile("itest")
	if err != nil {
		t.Fatal(err)
	}
	wanted := strings.Trim(string(f), "\n")

	o, err := os.OpenFile("otest", os.O_WRONLY, 0644)
	if err != nil {
		t.Fatal(err)
	}
	OUTPUT = bufio.NewWriter(o)
	program := []int{ 3, 0, 4, 0, 99 }

	Eval(program)
	f, err = ioutil.ReadFile("otest")
	if err != nil {
		t.Fatal(err)
	}
	got := strings.Trim(string(f), "\n")

	if wanted != got {
		t.Errorf("Wanted: %v, got: %v", wanted, got)
	}
}

func TestOpcode(t *testing.T) {
	og := 1002
	got := Opcode(og)
	wanted := Op{ 2, 3, []int{ 0, 1, 0 } }

	if !got.Equals(&wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, got)
	}

	wanted = Op{ 9, 1, []int{ 2 } }
	got = Opcode(209)

	if !got.Equals(&wanted) {
		t.Errorf("Wanted %v, got: %v", wanted, got)
	}
}

func TestImmediate(t *testing.T) {
	program := []int{ 1002, 4, 3, 4, 33 }
	wanted := []int{ 1002, 4, 3, 4, 99 }

	Eval(program)

	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}
}

func testJump(t *testing.T) {
	program := []int{ 105, 1, 7, 1102, 2, 3, 0, 99 }
	wanted := []int{ 105, 1, 7, 1102, 2, 3, 0, 99 }

	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}

	program = []int{ 105, 0, 7, 1102, 2, 3, 0, 99 }
	wanted = []int{ 5, 0, 7, 1102, 2, 3, 0, 99 }

	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)

	program = []int{ 106, 0, 7, 1102, 2, 3, 0, 99 }
	wanted = []int{ 106, 0, 7, 1102, 2, 3, 0, 99 }

	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}
	}

	program = []int{ 106, 1, 7, 1102, 2, 3, 0, 99 }
	wanted = []int{ 5, 1, 7, 1102, 2, 3, 0, 99 }

	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}
}

func TestCompare(t *testing.T) {
	program := []int{ 1107, 1, 2, 0, 99 }
	wanted := []int{ 1, 1, 2, 0, 99 }

	Eval(program)
	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}

	program = []int{ 1107, 1, 1, 0, 99 }
	wanted = []int{ 0, 1, 1, 0, 99 }

	Eval(program)
	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}

	program = []int{ 1107, 1, 0, 0, 99 }
	wanted = []int{ 0, 1, 0, 0, 99 }

	Eval(program)
	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}

	program = []int{ 1108, 1, 1, 0, 99 }
	wanted = []int{ 1, 1, 1, 0, 99 }

	Eval(program)
	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}

	program = []int{ 1108, 1, 0, 0, 99 }
	wanted = []int{ 0, 1, 0, 0, 99 }

	Eval(program)
	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}
}

func TestRBase(t *testing.T) {
	program := []int{ 1201, 1, 5, 0, 99 }
	wanted := []int{ 6, 1, 5, 0, 99 }

	Eval(program)
	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}

	program = []int{ 9, 2, 99 }
	wanted = []int{ 9, 2, 99 }

	Eval(program)
	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}

	program = []int{ 109, 2, 1201, 1, 5, 0, 99 }
	wanted = []int{ 6, 2, 1201, 1, 5, 0, 99 }

	Eval(program)
	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}
}

func TestOOB(t *testing.T) {
	program := []int{ 101, 2, 100, 0, 99 }
	wanted := []int{ 2, 2, 100, 0, 99 }

	Eval(program)
	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}

	program = []int{ 1101, 98, 1, 6, 4, 3 }
	wanted  = []int{ 1101, 98, 1, 6, 4, 3, 99 }

	program = Eval(program)
	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}
}

func Test210AddMult(t *testing.T) {
	program := []int{ 2102, 2, 1, 0, 99 }
	wanted  := []int{ 4, 2, 1, 0, 99 }

	program = Eval(program)
	if !intcodeEquals(program, wanted) {
		t.Errorf("Wanted: %v, got: %v", wanted, program)
	}
}
