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
	Next  *Line
}

type Wire struct {
	Horizontals []*Line
	Verticals   []*Line
	Start       *Line
}

func (p *Point) DistFrom(origin *Point) int {
	return abs(origin.X - p.X) + abs(origin.Y - p.Y)
}

func (l *Line) Contains(p *Point) bool {
	if l.End.Y == l.Start.Y {
		return ((p.X <= l.Start.X && p.X >= l.End.X)  ||
		        (p.X >= l.Start.X && p.X <= l.End.X)) &&
		        (p.Y == l.Start.Y)
	}
	return ((p.Y <= l.Start.Y && p.Y >= l.End.Y)  ||
	        (p.Y >= l.Start.Y && p.Y <= l.End.Y)) &&
	        (p.X == l.Start.X)
}

func (w *Wire) StepsTo(p *Point) int {
	cur := w.Start
	count := 0

	for cur != nil {
		if cur.Contains(p) {
			count += abs(p.X - cur.Start.X) + abs(p.Y - cur.Start.Y)
			return count
		}

		count += abs(cur.End.X - cur.Start.X) + abs(cur.End.Y - cur.Start.Y)
		cur = cur.Next
	}

	return -1
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

	if len(intersections) > 0 {
		nearest, dist := findNearest(paths, intersections)
		fmt.Println(nearest, dist)
	}
}

func findNearest(wires []*Wire, intersections []*Point) (*Point, int) {
	n := intersections[0]
	min := 0
	for i := 0; i < len(wires); i++ {
		min += wires[i].StepsTo(n)
	}

	for i := 1; i < len(intersections); i++ {
		steps := 0
		for j := 0; j < len(wires); j++ {
			steps += wires[j].StepsTo(intersections[i])
		}
		if steps >= 0 && steps < min {
			n = intersections[i]
			min = steps
		}
	}

	return n, min
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
	l := new(Line)
	w := Wire{ []*Line{}, []*Line{}, l }
	x := 0
	y := 0

	for i := 0; i < len(wire); i++ {
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
			w.Horizontals = append(w.Horizontals, l)
		case 'L':
			l.Start = &Point{ x, y }
			x -= n
			l.End = &Point{ x, y }
			w.Horizontals = append(w.Horizontals, l)
		case 'U':
			l.Start = &Point{ x, y }
			y += n
			l.End = &Point{ x, y }
			w.Verticals = append(w.Verticals, l)
		case 'D':
			l.Start = &Point{ x, y }
			y -= n
			l.End = &Point{ x, y }
			w.Verticals = append(w.Verticals, l)
		}

		if i < len(wire) - 1 {
			l.Next = new(Line)
			l = l.Next
		} else {
			l.Next = nil
			l = new(Line)
		}
	}

	return &w
}
