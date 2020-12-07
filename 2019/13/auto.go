package main

import (
	"bufio"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"time"

	"../intcode"
)

type Tile struct {
	X  int
	Y  int
	Id int
}

var ballX int
var pX    int
var ww *bufio.Writer

func main() {
	if len(os.Args) < 2 {
		os.Exit(1)
	}

	input, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		os.Exit(1)
	}

	r, w := io.Pipe()
	r1, w1 := io.Pipe()

//	intcode.INPUT  = bufio.NewReader(os.Stdin)
	intcode.INPUT  = bufio.NewReader(r1)
	intcode.OUTPUT = bufio.NewWriter(w)
	ww = bufio.NewWriter(w1)

	program, err := intcode.Parse(strings.Trim(string(input), "\n"))
	if err != nil {
		intcode.OUTPUT.WriteString("and i oop")
		os.Exit(1)
	}

	program[0] = 2
	done := false
	go func() { intcode.Eval(program); w.Close(); w1.Close(); done = true; }()
//	go func() { intcode.Eval(program); w.Close(); done = true; }()

	screen, score := generateScreen(r)
	go func() {
		for !done {
			time.Sleep(200 * time.Millisecond)
			if ballX > pX {
				ww.WriteString("1\n")
			} else if ballX < pX {
				ww.WriteString("-1\n")
			} else {
				ww.WriteString("0\n")
			}
			ww.Flush()
		}
	}()
	for !done {
		score = update(r, screen, score)
		draw(screen, score)
	}
}

func update(r *io.PipeReader, screen [][]*Tile, score int) int {
	scanner := bufio.NewScanner(r)
	t := new(Tile)
	s := score

	for i := 0; i < 3; i++ {
		scanner.Scan()
		o, _ := strconv.Atoi(scanner.Text())

		switch i % 3 {
		case 0:
			t.X = o
		case 1:
			t.Y = o
		case 2:
			if t.X == -1 && t.Y == 0 {
				s = o
			} else {
				t.Id = o
				screen[t.Y][t.X] = t
				t = new(Tile)
			}
		}
	}

	return s
}

func generateScreen(r *io.PipeReader) ([][]*Tile, int) {
	scanner := bufio.NewScanner(r)
	screen  := [][]*Tile{}
	t := new(Tile)
	s := 0

	for i := 0; i < 2220; i++ {
		scanner.Scan()
//	for i := 0; scanner.Scan(); i++ {
		o, _ := strconv.Atoi(scanner.Text())

		switch i % 3 {
		case 0:
			t.X = o
		case 1:
			t.Y = o
		case 2:
			if t.X == -1 && t.Y == 0 {
				s = o
			} else {
				t.Id = o

				if t.Y >= len(screen) {
					for i := len(screen); i <= t.Y; i++ {
						screen = append(screen, []*Tile{})
					}
				}
				if t.X >= len(screen[t.Y]) {
					for i := len(screen[t.Y]); i <= t.X; i++ {
						screen[t.Y] = append(screen[t.Y], nil)
					}
				}

				screen[t.Y][t.X] = t
				t = new(Tile)
			}
		}
	}

	return screen, s
}

func draw(screen [][]*Tile, score int) {
	for y := 0; y < len(screen); y++ {
		for x := 0; x < len(screen[y]); x++ {
			switch screen[y][x].Id {
			case 0:
				fmt.Print(" ")
			case 1:
				fmt.Print("\u2588")
			case 2:
				fmt.Print("\u2592")
			case 3:
				pX = x
				fmt.Print("\u2580")
			case 4:
				ballX = x
				fmt.Print("#")
			}
		}
		fmt.Println()
	}
	fmt.Println(score)
}
