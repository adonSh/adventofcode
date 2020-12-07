package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Point struct {
	X int
	Y int
}

type Line struct {
	Start *Point
	End   *Point
}

type Wire struct {
	Horizontals []*Line
	Verticals   []*Line
}

func (p *Point) DistFrom(origin *Point) int {
	return abs(origin.X - p.X) + abs(origin.Y - p.Y)
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
	paths := []*Wire{}

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

func intersects(h *Line, v *Line) bool {
	if (h.Start.X < v.Start.X && h.End.X > v.Start.X) ||
	   (h.End.X < v.Start.X && h.Start.X > v.Start.X) {
		if (v.Start.Y < h.Start.Y && v.End.Y > h.Start.Y) ||
		   (v.End.Y < h.Start.Y && v.Start.Y > h.Start.Y) {
			return true
		}
	}

	return false
}

func abs(n int) int {
	if n < 0 {
		return -n
	}
	return n
}

func findIntersections(wires []*Wire) []*Point {
	intersections := []*Point{}
	one := wires[0]
	two := wires[1]

	// horizontals x verticals
	for i := 0; i < len(one.Horizontals); i++ {
		y := one.Horizontals[i].Start.Y
		for j := 0; j < len(two.Verticals); j++ {
			x := two.Verticals[j].Start.X
			if intersects(one.Horizontals[i], two.Verticals[j]) {
				intersections = append(intersections, &Point{ x, y })
			}
		}
	}
	// verticals x horizontals
	for i := 0; i < len(one.Verticals); i++ {
		x := one.Verticals[i].Start.X
		for j := 0; j < len(two.Horizontals); j++ {
			y := two.Horizontals[j].Start.Y
			if intersects(two.Horizontals[j], one.Verticals[i]) {
				intersections = append(intersections, &Point{ x, y })
			}
		}
	}

	return intersections
}

func traceWire(wire []string) *Wire {
	w := Wire{ []*Line{}, []*Line{} }
	x := 0
	y := 0

	for i := 0; i < len(wire); i++ {
		var l Line
		n, err := strconv.Atoi(wire[i][1:])
		if err != nil {
			fmt.Fprintln(os.Stderr, "Bad Input")
			os.Exit(1)
		}
		switch wire[i][0] {
		case 'R':
			l.Start = &Point{ x, y }
			x += n
			l.End = &Point{ x, y }
			w.Horizontals = append(w.Horizontals, &l)
		case 'L':
			l.Start = &Point{ x, y }
			x -= n
			l.End = &Point{ x, y }
			w.Horizontals = append(w.Horizontals, &l)
		case 'U':
			l.Start = &Point{ x, y }
			y += n
			l.End = &Point{ x, y }
			w.Verticals = append(w.Verticals, &l)
		case 'D':
			l.Start = &Point{ x, y }
			y -= n
			l.End = &Point{ x, y }
			w.Verticals = append(w.Verticals, &l)
		}
	}

	return &w
}
