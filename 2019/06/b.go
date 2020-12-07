package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

type Body struct {
	Name string
	Sats []*Body
}

func main() {
	if len(os.Args) < 2 {
		os.Exit(1)
	}

	bodies   := make(map[string][]string)
	input, _ := os.Open(os.Args[1])
	scanner  := bufio.NewScanner(input)

	for scanner.Scan() {
		orbit := strings.Split(scanner.Text(), ")")
		_, ok := bodies[orbit[0]]

		if ok {
			bodies[orbit[0]] = append(bodies[orbit[0]], orbit[1])
		} else {
			bodies[orbit[0]] = []string{ orbit[1] }
		}
	}

	src := "YOU"
	dst := "SAN"
	if len(os.Args) == 4 {
		src = os.Args[2]
		dst = os.Args[3]
	}

	fmt.Println(shortestRoute(bodies, src, dst))
}

func shortestRoute(all map[string][]string, a string, b string) int {
	parents := []string{}

	for k, v := range all {
		if hasSat(all, v, a) && hasSat(all, v, b) {
			parents = append(parents, k)
		}
	}

	min := jumpsTo(all, parents[0], a) + jumpsTo(all, parents[0], b)
	for i := 1; i < len(parents); i++ {
		dist := jumpsTo(all, parents[i], a) + jumpsTo(all, parents[i], b)
		if dist < min {
			min = dist
		}
	}

	return min
}

func hasSat(all map[string][]string, cur []string, sat string) bool {
	for i := 0; i < len(cur); i++ {
		if cur[i] == sat {
			return true
		}
	}
	has := false
	for i := 0; i < len(cur); i++ {
		has = has || hasSat(all, all[cur[i]], sat)
	}

	return has
}

func countOrbits(all map[string][]string, cur []string) int {
	return DFS(all, cur, 0)
}

func jumpsTo(all map[string][]string, src string, dst string) int {
	return DFSTo(all, all[src], dst, 0)
}

func DFSTo(all map[string][]string, cur []string, end string, depth int) int {
	for i := 0; i <len(cur); i++ {
		if cur[i] == end {
			return depth
		}
	}

	sats_depth := 0
	for i := 0; i < len(cur); i++ {
		if hasSat(all, cur, end) {
			sats_depth += DFSTo(all, all[cur[i]], end, depth + 1)
		}
	}

	return sats_depth
}

func DFS(all map[string][]string, cur []string, depth int) int {
	sats_depth := 0
	for i := 0; i < len(cur); i++ {
		sats_depth += DFS(all, all[cur[i]], depth + 1)
	}

	return depth + sats_depth
}
