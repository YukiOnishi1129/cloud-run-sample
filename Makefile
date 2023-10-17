include .env

# 空実行 (make だけで実行して事故が怒らないように)
empty:
	echo "空実行"

# 開発環境のdocker-composeコマンド
dcb-dev:
	docker-compose -f docker-compose.dev.yml build
dcu-dev:
	docker-compose -f docker-compose.dev.yml up -d
dcd-dev:
	docker-compose -f docker-compose.dev.yml down
# 本番環境のdocker-composeコマンド
dcb-prod:
	docker-compose build
dcu-prod:
	docker-compose up -d

# コンテナ環境へsshログイン
front-ssh:
	docker exec -it ${FRONTEND_CONTAINER_NAME} sh
front-stand-ssh:
	docker exec -it ${FRONTEND_CONTAINER_NAME}_standalone sh
backend-ssh:
	docker exec -it ${BACKEND_CONTAINER_NAME} sh
db-ssh:
	docker exec -it ${POSTGRES_HOST} /bin/bash

# DB関連
## 初期セットアップ (初回のみ)
db-setup:
	make db-migrate && make db-seed
## マイグレーション
db-migrate:
	docker exec -it ${BACKEND_CONTAINER_NAME} sh -c "migrate -source file://database/migrations -database 'postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable' up"
## シーダー
db-seed:
	docker exec -it ${BACKEND_CONTAINER_NAME} sh -c "go run database/seed/seed.go"
## ロールバック
db-rollback:
	docker exec -it ${BACKEND_CONTAINER_NAME} sh -c "migrate -source file://database/migrations -database 'postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable' down"
## DBリセット
db-reset:
	make db-rollback && make db-migrate && make db-seed

# フロント側のnpmコマンド (コンテナ内でライブラリをinstallしないと不具合が発生する)
## 複数のライブラリを指定する場合は、name="axios jest" のように""で囲んで実行すること
## 参考: https://please-sleep.cou929.nu/gnu-make-spaces-in-pathname.html
front-add-library:
	docker exec -it ${FRONTEND_CONTAINER_NAME} sh -c "npm i ${name}"
front-add-library-dev:
	docker exec -it ${FRONTEND_CONTAINER_NAME} sh -c "npm i -D ${name}"
front-remove-library:
	docker exec -it ${FRONTEND_CONTAINER_NAME} sh -c "npm uninstall ${name}"


# ローカル開発用
# create entity
backend-create-entity:
	 sqlboiler psql -c backend/database.toml -o backend/database/entity -p entity --no-tests --wipe
# create table sql
db-create-table-sql:
	docker exec -it ${BACKEND_CONTAINER_NAME} sh -c "migrate  create -ext sql -dir database/migrations -seq ${name}"
## gqlgen
backend-gqlgen:
	cd backend && gqlgen generate