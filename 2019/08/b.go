package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
)

func main() {
	if len(os.Args) < 2 {
		os.Exit(1)
	}

	width  := 25
	height := 6
	if len(os.Args) == 4 {
		width, _  = strconv.Atoi(os.Args[2])
		height, _ = strconv.Atoi(os.Args[3])
	}

	input, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		os.Exit(1)
	}

	img := parse(input, width, height)

	draw(render(img, width, height))
}

func draw(img []string) {
	for i := 0; i < len(img); i++ {
		for j := 0; j < len(img[i]); j++ {
			if img[i][j] == '0' {
				fmt.Print("\u2588")
			} else {
				fmt.Print(" ")
			}
		}
		fmt.Print("\n")
	}
}

func render(img [][]string, w int, h int) []string {
	final := []string{}

	for i := 0; i < h; i++ {
		s := ""
		for j := 0; j < w; j++ {
			innermost:
			for k := 0; k < len(img); k++ {
				if img[k][i][j] != '2' {
					s += string(img[k][i][j])
					break innermost
				}
			}
		}
		final = append(final, s)
	}

	return final
}

func countDigit(layer []string, d byte) int {
	count := 0

	for i := 0; i < len(layer); i++ {
		for j := 0; j < len(layer[i]); j++ {
			if layer[i][j] == d {
				count += 1
			}
		}
	}

	return count
}

func productOfLeast0s(img [][]string) int {
	least0s := img[0]
	for i := 1; i < len(img); i++ {
		if countDigit(img[i], '0') < countDigit(least0s, '0') {
			least0s = img[i]
		}
	}
	ones := countDigit(least0s, '1')
	twos := countDigit(least0s, '2')

	return ones * twos
}

func parse(input []byte, width int, height int) [][]string {
	img   := [][]string{}
	layer := []string{}
	words := 0

	for i := 0; i < len(input) - 1; i += width {
		layer = append(layer, string(input[i:i + width]))
		if i != 0 && words % height == height - 1 {
			img = append(img, layer)
			layer = []string{}
		}
		words += 1
	}

	return img
}
