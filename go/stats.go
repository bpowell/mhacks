package main

import (
	"sort"
	"math"
)

func Median(data []int) int {
	sort.Ints(data)
	index := math.Floor(float64(len(data))/2.0)
	return data[int(index)]
}

func online_variance(data []int) float64 {
	n := 0
	mean := 0
	M2 := 0

	for _, value := range data {
		n = n + 1
		delta := value - mean
		mean = mean + delta / n
		M2 = M2 + delta * (value - mean)
	}

	if n==1 {
		return 0
	}

	return math.Sqrt(float64(M2 / (n - 1)))
}

func average(data []int) float64 {
	total := 0
	for _, value := range data {
		total = total + value
	}

	return float64(total)/float64(len(data))
}
