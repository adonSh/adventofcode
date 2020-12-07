package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"sort"
	"strconv"
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
	sights  := []map[Ray][]*Point{}

	for row := 0; row < len(stroids); row++ {
		for col := 0; col < len(stroids[row]); col++ {
			if stroids[row][col] == '#' {
				coords = append(coords, &Point{ float64(col), float64(row) })
			}
		}
	}

	for i := 0; i < len(coords); i++ {
		sights = append(sights, rayMap(coords[i], coords))
	}

	most := 0
	for i := 1; i < len(sights); i++ {
		if len(sights[i]) > len(sights[most]) {
			most = i
		}
	}

	sorted_rays := sortRays(sights[most], coords[most])
	twohundred := vaporize(sights[most], sorted_rays)

	fmt.Println(twohundred)
}

func sortRays(ray map[Ray][]*Point, station *Point) []Ray {
	rs := []Ray{}

	for k := range ray {
		rs = append(rs, k)
		sort.Slice(ray[k], func(a, b int) bool {
			return dist(ray[k][a], station) < dist(ray[k][b], station)
		})
	}

	sort.Slice(rs, func(a, b int) bool {
		if rs[a].After && !rs[b].After {
			return true
		} else if !rs[a].After && rs[b].After {
			return false
		}
		return rs[a].Slope > rs[b].Slope
	})

	return rs
}

func rayMap(p *Point, coords []*Point) map[Ray][]*Point {
	ray := make(map[Ray][]*Point)

	for i := 0; i < len(coords); i++ {
		if *p != *coords[i] {
			r := lineOfSight(p, coords[i])
			ray[*r] = append(ray[*r], coords[i])
		}
	}

	return ray
}

func vaporize(station map[Ray][]*Point, sights []Ray) *Point {
	n := 200
	a := new(Point)
	counter := 0

	for i := 0; i < len(sights); i++ {
		astrds, ok := station[sights[i]]
		if ok {
			counter += 1
			if len(os.Args) > 2 {
				n, _ = strconv.Atoi(os.Args[2])
			}
			if counter == n {
				a = astrds[0]
			}
			astrds = astrds[1:]
		}
	}

	return a
}

func lineOfSight(p1 *Point, p2 *Point) *Ray {
	r := Ray{ (p1.Y - p2.Y) / (p2.X - p1.X), true }

	if p1.X > p2.X {
		r.After = false
	}

	return &r
}

func dist(src *Point, dst *Point) float64 {
	return abs(src.X - dst.X) + abs(src.Y - dst.Y)
}

func abs(n float64) float64 {
	if n < 0 {
		return -n
	}
	return n
}
