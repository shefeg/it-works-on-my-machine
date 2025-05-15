create-network:
	@echo "Creating network..."
	docker network create backend-network

backend-build-go:
	@echo "Building backend go"
	DOCKER_BUILDKIT=0 docker build -f backend/Dockerfile -t go-backend backend

backend-run-go:
	docker run -d --name go-backend \
	  --network backend-network \
	  -e "PORT=8080" \
	  -e "DB_ENDPOINT=backend-postgres" \
	  -e "DB_PORT=5432" \
	  -e "DB_USER=course_user" \
	  -e "DB_PASS=course_pass" \
	  -e "DB_NAME=course_db" \
	  -e "DEBUG=true" \
	  -e "REDIS_ENDPOINT=backend-redis" \
	  -e "REDIS_PORT=6379" \
	  -p 8080:8080 \
 		 go-backend

backend-run-postgres:
	docker run -d \
      --name backend-postgres \
      --network backend-network \
      -e POSTGRES_DB=course_db \
      -e POSTGRES_USER=course_user \
      -e POSTGRES_PASSWORD=course_pass \
      -v "./backend/db_schema.sql:/docker-entrypoint-initdb.d/schema.sql:ro" \
      -p 5433:5432 \
      postgres:16

backend-run-redis:
	docker run -d \
      --name backend-redis \
      --network backend-network \
      -p 6379:6379 \
      redis

frontend-build:
	@echo "Building frontend go"
	docker build -f frontend/Dockerfile -t frontend-app ./frontend

frontend-run:
	docker run --name frontend-app \
	  --network backend-network \
	  -e "REACT_APP_BACKEND_URL=http://localhost:8080" \
	  -p 3000:3000 \
 		 frontend-app