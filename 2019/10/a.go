package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
)

type Point struct {
	X float64
	Y float64
}

type Ray struct {
	Slope float64
	After bool
}

func main() {
	if len(os.Args) < 2 {
		os.Exit(1)
	}

	input, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		os.Exit(1)
	}

	stroids := bytes.Split(input[:len(input) - 1], []byte("\n"))
	coords  := []*Point{}

	for row := 0; row < len(stroids); row++ {
		for col := 0; col < len(stroids[row]); col++ {
			if stroids[row][col] == '#' {
				coords = append(coords, &Point{ float64(col), float64(row) })
			}
		}
	}

	sights := []map[Ray]bool{}

	for i := 0; i < len(coords); i++ {
		sights = append(sights, make(map[Ray]bool))
		for j := 0; j < len(coords); j++ {
			if i != j {
				sights[i][*lineOfSight(coords[i], coords[j])] = true
			}
		}
	}

	most := 0
	for i := 1; i < len(sights); i++ {
		if len(sights[i]) > len(sights[most]) {
			most = i
		}
	}

	fmt.Println(coords[most], len(sights[most]))
}

func lineOfSight(p1 *Point, p2 *Point) *Ray {
	r := Ray{ (p1.Y - p2.Y) / (p2.X - p1.X), true }

	if p1.X > p2.X {
		r.After = false
	}

	return &r
}
