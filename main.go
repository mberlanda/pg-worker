package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"time"

	_ "github.com/lib/pq"
)

const (
	host     = "localhost"
	port     = 5432
	user     = "postgres"
	password = ""
	dbname   = "worker_test"
)

func buildConnectionString() string {
	return fmt.Sprintf("host=%s port=%d user=%s "+
		"dbname=%s sslmode=disable",
		host, port, user, dbname)
}

type Table struct {
	Name   string `json:"name"`
	Schema string `json:"schema"`
}

func task() {
	fmt.Println("Task started")
	db, err := sql.Open("postgres", buildConnectionString())
	if err != nil {
		panic(err)
	}
	defer db.Close()

	statement := `SELECT schemaname, tablename FROM pg_catalog.pg_tables`

	rows, _ := db.Query(statement)
	defer rows.Close()

	for rows.Next() {
		t := Table{}

		rows.Scan(&t.Schema, &t.Name)
		j, _ := json.Marshal(t)
		fmt.Println(string(j))
	}
	fmt.Println("Task Completed")
}

func main() {
	fmt.Println("Program Started")
	task()

	ticker := time.NewTicker(5 * time.Second)
	quit := make(chan struct{})
	// go func() {
	for {
		select {
		case <-ticker.C:
			task()
		case <-quit:
			ticker.Stop()
			fmt.Println("Gracefully shutdown")
			return
		}
	}
	// }()
	// close(quit)
}
