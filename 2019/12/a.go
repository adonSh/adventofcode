package main

import (
	"errors"
	"fmt"
	"bufio"
	"os"
	"strconv"
	"strings"
)

type Coor3d struct {
	X int
	Y int
	Z int
}

type Moon struct {
	Pos *Coor3d
	Vel *Coor3d
}

func main() {
	if len(os.Args) < 3 {
		os.Exit(1)
	}

	input, err := os.Open(os.Args[1])
	if err != nil {
		os.Exit(1)
	}

	steps, err := strconv.Atoi(os.Args[2])
	if err != nil {
		os.Exit(1)
	}

	scanner := bufio.NewScanner(input)
	moons   := []*Moon{}
	energy  := 0

	for scanner.Scan() {
		c, err := parse(strings.Trim(scanner.Text(), " "))
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
		moons = append(moons, &Moon{ c, new(Coor3d) })
	}

	for i := 0; i < steps; i++ {
		simulate(moons)
	}

	for i := 0; i < len(moons); i++ {
		energy += potential(moons[i]) * kinetic(moons[i])
	}

	fmt.Println(energy)
}

func kinetic(m *Moon) int {
	return abs(m.Vel.X) + abs(m.Vel.Y) + abs(m.Vel.Z)
}

func potential(m *Moon) int {
	return abs(m.Pos.X) + abs(m.Pos.Y) + abs(m.Pos.Z)
}

func simulate(moons []*Moon) {
	for i := 0; i < len(moons); i++ {
		for j := i + 1; j < len(moons); j++ {
			updateVelocity(moons[i], moons[j])
		}
		updatePosition(moons[i])
	}
}

func updatePosition(m *Moon) {
	m.Pos.X += m.Vel.X
	m.Pos.Y += m.Vel.Y
	m.Pos.Z += m.Vel.Z
}

func updateVelocity(a *Moon, b *Moon) {
	if a.Pos.X < b.Pos.X {
		a.Vel.X += 1
		b.Vel.X -= 1
	} else if a.Pos.X > b.Pos.X {
		a.Vel.X -= 1
		b.Vel.X += 1
	}

	if a.Pos.Y < b.Pos.Y {
		a.Vel.Y += 1
		b.Vel.Y -= 1
	} else if a.Pos.Y > b.Pos.Y {
		a.Vel.Y -= 1
		b.Vel.Y += 1
	}

	if a.Pos.Z < b.Pos.Z {
		a.Vel.Z += 1
		b.Vel.Z -= 1
	} else if a.Pos.Z > b.Pos.Z {
		a.Vel.Z -= 1
		b.Vel.Z += 1
	}
}

func parse(position string) (*Coor3d, error) {
	e_invalid := errors.New("invalid moon coordinates")

	if position[0] != '<' || position[len(position) - 1] != '>' {
		return nil, e_invalid
	}

	axes := strings.Split(position[1:len(position) -1], ",")
	if len(axes) != 3 {
		return nil, e_invalid
	}

	var err error
	c := new(Coor3d)
	for i := 0; i < len(axes); i++ {
		a := strings.Split(axes[i], "=")
		a[0] = strings.Trim(a[0], " ")
		a[1] = strings.Trim(a[1], " ")

		if a[0] == "x" {
			c.X, err = strconv.Atoi(a[1])
		} else if a[0] == "y" {
			c.Y, err = strconv.Atoi(a[1])
		} else if a[0] == "z" {
			c.Z, err = strconv.Atoi(a[1])
		} else {
			return nil, e_invalid
		}

		if err != nil {
			return nil, e_invalid
		}
	}

	return c, nil
}

func abs(n int) int {
	if n < 0 {
		return -n
	}

	return n
}
