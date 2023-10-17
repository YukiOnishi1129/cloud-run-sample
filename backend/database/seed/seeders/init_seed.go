package seeders

import (
	"database/sql"
)

var (
	err error
)

func CreateTestData(con *sql.DB) error {
	// usersテーブルのテストデータ作成
	if err = CreateUserData(con); err != nil {
		return err
	}
	// todoテーブルのテストデータ作成
	if err = CreateTodoData(con); err != nil {
		return err
	}

	return nil
}
