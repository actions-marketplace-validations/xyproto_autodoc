package main

import (
	"encoding/json"
	"net/http"
	"sync"
)

type Vegetable struct {
	Name     string  `json:"name"`
	Size     float64 `json:"size"`     // Size in centimeters
	Vibrancy int     `json:"vibrancy"` // Vibrancy on a scale of 1-10
}

var (
	vegetables = make(map[string]Vegetable)
	mu         sync.RWMutex
)

func main() {
	http.HandleFunc("/vegetables", handleVegetables)
	http.ListenAndServe(":8080", nil)
}

func handleVegetables(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		getVegetables(w, r)
	case "POST":
		addVegetable(w, r)
	default:
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
	}
}

func getVegetables(w http.ResponseWriter, r *http.Request) {
	mu.RLock()
	defer mu.RUnlock()

	veggieList := make([]Vegetable, 0, len(vegetables))
	for _, veggie := range vegetables {
		veggieList = append(veggieList, veggie)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(veggieList)
}

func addVegetable(w http.ResponseWriter, r *http.Request) {
	var veggie Vegetable
	if err := json.NewDecoder(r.Body).Decode(&veggie); err != nil {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}

	if veggie.Name == "" || veggie.Size <= 0 || veggie.Vibrancy < 1 || veggie.Vibrancy > 10 {
		http.Error(w, "Invalid vegetable data", http.StatusBadRequest)
		return
	}

	mu.Lock()
	vegetables[veggie.Name] = veggie
	mu.Unlock()

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(veggie)
}
