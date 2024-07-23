package day3

import (
	"bufio"
	"os"
	"strconv"
	"strings"
)

func Pt1() int {
	var fileArr [][]string

	file, _ := os.Open("input/day3.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		fileArr = append(fileArr, strings.Split(scanner.Text(), ""))
	}

	var results []int

	for x, line := range fileArr {
		for y, char := range line {
			_, err := strconv.Atoi(char)

			if err != nil && char != "." {
				// symbol
				results = append(results, findPartNumbers(fileArr, x, y)...)
			}
		}
	}

	return sum(results)
}

func findPartNumbers(fileArr [][]string, x int, y int) []int {
	var res []int
	top_coords := [3][2]int{{x - 1, y - 1}, {x - 1, y}, {x - 1, y + 1}}
	mid_coords := [2][2]int{{x, y - 1}, {x, y + 1}}
	low_coords := [3][2]int{{x + 1, y - 1}, {x + 1, y}, {x + 1, y + 1}}

	var top_res []int
	for _, coord := range top_coords {
		qX := coord[0]
		qY := coord[1]

		if qX >= 0 && qY >= 0 {
			_, err := strconv.Atoi(fileArr[qX][qY])

			if err == nil {
				top_res = append(top_res, getContiguousNumber(fileArr, qX, qY))
			}
		}
	}

	for _, coord := range mid_coords {
		qX := coord[0]
		qY := coord[1]

		if qX >= 0 && qY >= 0 {
			_, err := strconv.Atoi(fileArr[qX][qY])

			if err == nil {
				res = append(res, getContiguousNumber(fileArr, qX, qY))
			}
		}
	}

	var low_res []int
	for _, coord := range low_coords {
		qX := coord[0]
		qY := coord[1]

		if qX >= 0 && qY >= 0 {
			_, err := strconv.Atoi(fileArr[qX][qY])

			if err == nil {
				low_res = append(low_res, getContiguousNumber(fileArr, qX, qY))
			}
		}
	}

	return append(append(res, dedupe(low_res)...), dedupe(top_res)...)
}

func dedupe(arr []int) []int {
	var res []int
	m := make(map[int]bool)

	for _, n := range arr {
		m[n] = true
	}

	for k := range m {
		res = append(res, k)
	}

	return res
}

func getContiguousNumber(fileArr [][]string, x int, y int) int {
	startY := y
	endY := y

	for startY > 0 {
		_, err := strconv.Atoi(fileArr[x][startY-1])

		if err != nil {
			break
		}

		startY -= 1
	}

	for endY < len(fileArr) {
		_, err := strconv.Atoi(fileArr[x][endY])

		if err != nil {
			break
		}

		endY += 1
	}

	str := ""

	for i := startY; i < endY; i++ {
		str += fileArr[x][i]
	}

	res, _ := strconv.Atoi(str)

	// fmt.Printf("startY %d, endY %d, substr %v ------ %d", startY, endY, str, res)
	// fmt.Println()
	return res
}

func sum(arr []int) int {
	sum := 0

	for _, k := range arr {
		sum += k
	}

	return sum
}
