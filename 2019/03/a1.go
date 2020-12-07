package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
	"sync"
)

type Point struct {
	X int
	Y int
}

func (p *Point) DistFrom(origin *Point) int {
	return abs(origin.X - p.X) + abs(origin.Y - p.Y)
}

func abs(n int) int {
	if n < 0 {
		return -n
	}
	return n
}

func main() {
	if len(os.Args) < 2 {
		os.Exit(1)
	}

	input, err := os.Open(os.Args[1])
	if err != nil {
		os.Exit(1)
	}
	scanner := bufio.NewScanner(input)
	paths   := [][]*Point{}

	for scanner.Scan() {
		wire := strings.Split(scanner.Text(), ",")
		paths = append(paths, traceWire(wire))
	}

	intersections := findIntersections(paths)
	origin := Point{ 0, 0 }
	var nearest *Point

	if len(intersections) > 0 {
		nearest = intersections[0]
	}
	for i := 0; i < len(intersections); i++ {
		if nearest.DistFrom(&origin) > intersections[i].DistFrom(&origin) {
			nearest = intersections[i]
		}
	}
	fmt.Println(nearest, nearest.DistFrom(&origin))
}

func findIntersections(wires [][]*Point) []*Point {
	intersections := []*Point{}
	var wg sync.WaitGroup
	ch := make(chan *Point)
	var longest *[]*Point

	if len(wires) > 0 {
		longest = &wires[0]
	}
	for i := 0; i < len(wires); i++ {
		if len(wires[i]) > len(*longest) {
			longest = &wires[i]
		}
	}
	for i := 0; i < len(*longest); i++ {
		wg.Add(1)
		go func(p *Point) {
			for j := 0; j < len(wires); j++ {
				if &wires[j] != longest {
					for k := 0; k < len(wires[j]); k++ {
						if *wires[j][k] == *p {
							ch <- p
						}
					}
				}
			}
			wg.Done()
		}((*longest)[i])
	}
	go func() { wg.Wait(); close(ch) }()
	for i := range ch {
		intersections = append(intersections, i)
	}

	return intersections
}

func traceWire(wire []string) []*Point {
	ps := []*Point{}
	x  := 0
	y  := 0

	for i := 0; i < len(wire); i++ {
		n, err := strconv.Atoi(wire[i][1:])
		if err != nil {
			fmt.Fprintln(os.Stderr, "Bad Input")
			os.Exit(1)
		}
		switch wire[i][0] {
		case 'R':
			for i := 0; i < n; i++ {
				x += 1
				ps = append(ps, &Point{ x, y })
			}
		case 'L':
			for i := 0; i < n; i++ {
				x -= 1
				ps = append(ps, &Point{ x, y })
			}
		case 'U':
			for i := 0; i < n; i++ {
				y += 1
				ps = append(ps, &Point{ x, y })
			}
		case 'D':
			for i := 0; i < n; i++ {
				y -= 1
				ps = append(ps, &Point{ x, y })
			}
		}
	}

	return ps
}
