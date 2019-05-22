package main

import (
	"database/sql"
	"encoding/json"
	"fmt"

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

func main() {
	fmt.Println("Program Started")

	db, err := sql.Open("postgres", buildConnectionString())
	if err != nil {
		panic(err)
	}
	defer db.Close()

	statement := `SELECT schemaname, tablename FROM pg_catalog.pg_tables`
	// WHERE schemaname != 'pg_catalog'
	// AND schemaname != 'information_schema';`

	rows, _ := db.Query(statement)
	defer rows.Close()

	for rows.Next() {
		t := Table{}

		rows.Scan(&t.Schema, &t.Name)
		j, _ := json.Marshal(t)
		fmt.Println(string(j))
	}

}
