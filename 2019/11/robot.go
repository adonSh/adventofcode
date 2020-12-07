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

type Point struct {
	X int
	Y int
}

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

	r_in, w_in    := io.Pipe()
	r_out, w_out  := io.Pipe()
	intcode.INPUT  = bufio.NewReader(r_in)
	intcode.OUTPUT = bufio.NewWriter(w_out)

	in  := bufio.NewWriter(w_in)
	out := bufio.NewScanner(r_out)
	x   := 0
	y   := 0
	dir := 0
	colors := map[Point]string{}

	go func() { intcode.Eval(program); w_in.Close(); w_out.Close(); }()

	in.WriteString("1\n")
	in.Flush()
	for i := 0; out.Scan(); i++ {
		if i % 2 == 0 {
			c := out.Text()
			colors[Point{x, y}] = c
		} else {
			t := out.Text()

			if t == "0" {
				dir = mod(dir - 1, 4)
			} else if t == "1" {
				dir = mod(dir + 1, 4)
			}
			switch dir {
			case 0:
				y -= 1
			case 1:
				x +=1
			case 2:
				y += 1
			case 3:
				x -= 1
			}

			if c := colors[Point{x, y}]; c != "" {
				in.WriteString(colors[Point{x, y}] + "\n")
			} else {
				in.WriteString("0\n")
			}
			in.Flush()
		}
	}

	fmt.Println(len(colors))
	mx, my := minXY(colors)
	draw(colors, mx, my)
}

func minXY(colors map[Point]string) (int, int) {
	minX := 0
	minY := 0

	for k := range colors {
		if k.X < minX {
			minX = k.X
		}
		if k.Y < minY {
			minY = k.Y
		}
	}

	return minX, minY
}

func draw(colors map[Point]string, minX, minY int) {
	canvas := [][]string{}

	for k, v := range colors {
		for len(canvas) <= k.Y - minY {
			canvas = append(canvas, []string{})
		}

		for len(canvas[k.Y - minY]) <= k.X - minX {
			canvas[k.Y - minY] = append(canvas[k.Y - minY], "")
		}

		canvas[k.Y - minY][k.X - minX] = v
	}

	for i := 0; i < len(canvas); i ++ {
		for j := 0; j < len(canvas[i]); j++ {
			if canvas[i][j] == "0" {
				fmt.Print("\u2588")
			} else {
				fmt.Print(" ")
			}
		}
		fmt.Println()
	}
}

func mod(a int, b int) int {
	m := a % b

	if (m < 0  && b > 0) || (m > 0 && b < 0) {
		m += b
	}

	return m
}
