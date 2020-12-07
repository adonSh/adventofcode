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

	fmt.Println(countOrbits(bodies, bodies["COM"]))
}

func countOrbits(all map[string][]string, cur []string) int {
	if len(cur) == 0 {
		return 0
	}

	orbits := DFS(all, cur, 0)

	return orbits
}

func DFS(all map[string][]string, cur []string, depth int) int {
	sats_depth := 0
	for i := 0; i < len(cur); i++ {
//		fmt.Print(cur[i] + ": ")
		sats_depth += DFS(all, all[cur[i]], depth + 1)
	}

//	fmt.Println(cur, depth)
	return depth + sats_depth
}
