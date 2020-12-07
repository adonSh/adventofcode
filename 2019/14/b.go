package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

type Chemical struct {
	Amnt int
	Nm   string
}

type Equation struct {
	In  []*Chemical
	Out *Chemical
}

func main() {
	if len(os.Args) < 2 {
		os.Exit(1)
	}

	input, err := os.Open(os.Args[1])
	if err != nil {
		os.Exit(1)
	}
	scanner   := bufio.NewScanner(input)
	reactions := []*Equation{}

	for scanner.Scan() {
		reactions = append(reactions, parse(scanner.Text()))
	}

	fmt.Println(outcome(reactions, "FUEL", 1000000000000))
}

func outcome(ref []*Equation, target string, ore int) int {
	ta := ore / requiredFor(ref, target, 1, make(map[string]int))
	fuel := 0
	leftover := make(map[string]int)

	for ore > 0 && ta > 0 {
		nu := make(map[string]int)
		for k, v := range leftover {
			nu[k] = v
		}
		ore_used := requiredFor(ref, target, ta, nu)
		if ore_used > ore {
			ta /= 2
		} else {
			fuel += ta
			ore -= ore_used
			leftover = nu
		}
	}

	return fuel
}

func requiredFor(ref []*Equation, target string, amnt int, leftover map[string]int) int {
	if target == "ORE" {
		return amnt
	} else if amnt <= leftover[target] {
		leftover[target] -= amnt
		return 0
	}

	var e *Equation
	for i := 0; i < len(ref); i++ {
		if ref[i].Out.Nm == target {
			e = ref[i]
		}
	}

	amnt -= leftover[target]
	leftover[target] = 0
	ore := 0
	copies := math.Ceil(float64(amnt) / float64(e.Out.Amnt))

	for i := 0; i < len(e.In); i++ {
		ia := e.In[i].Amnt * int(copies)
		ore += requiredFor(ref, e.In[i].Nm, ia, leftover)
	}
	leftover[target] += e.Out.Amnt * int(copies) - amnt

	return ore
}

func parse(input string) *Equation {
	in, out := tokenize(input)
	e := new(Equation)

	e.Out = new(Chemical)
	e.Out.Amnt, _ = strconv.Atoi(out[0])
	e.Out.Nm = out[1]

	for i := 0; i < len(in); i++ {
		c := new(Chemical)

		c.Amnt, _ = strconv.Atoi(in[i][0])
		c.Nm = in[i][1]
		e.In = append(e.In, c)
	}

	return e
}

func tokenize(input string) ([][]string, []string) {
	sides := strings.Split(input, " => ")
	left  := strings.Split(sides[0], ", ")
	right := sides[1]

	inputs := [][]string{}
	for i := 0; i < len(left); i++ {
		inputs = append(inputs, strings.Split(left[i], " "))
	}
	output := strings.Split(right, " ")

	return inputs, output
}
