# Tax Insights - Main Makefile
# Commands to install and run both backend and frontend

.PHONY: help install install-backend install-frontend run run-backend run-frontend dev build clean

# Default target
help:
	@echo "Available commands:"
	@echo "  install          - Install dependencies for both backend and frontend"
	@echo "  install-backend  - Install backend dependencies (Poetry)"
	@echo "  install-frontend - Install frontend dependencies (npm)"
	@echo "  run              - Run both backend and frontend in development mode"
	@echo "  run-backend      - Run backend server only"
	@echo "  run-frontend     - Run frontend server only"
	@echo "  dev              - Run both services in development mode (alias for run)"
	@echo "  build            - Build both backend and frontend for production"
	@echo "  clean            - Clean build artifacts and dependencies"

# Install all dependencies
install: install-backend install-frontend
	@echo "All dependencies installed successfully!"

# Install backend dependencies
install-backend:
	@echo "Installing backend dependencies..."
	cd backend && poetry install
	@echo "Backend dependencies installed!"

# Install frontend dependencies
install-frontend:
	@echo "Installing frontend dependencies..."
	cd frontend && pnpm install
	@echo "Frontend dependencies installed!"

# Run both backend and frontend
run: dev

dev:
	@echo "Starting both backend and frontend servers..."
	@echo "Backend will run on http://localhost:8000"
	@echo "Frontend will run on http://localhost:3000"
	@echo "Press Ctrl+C to stop both servers"
	@$(MAKE) -j2 run-backend run-frontend

# Run backend only (using Docker Compose)
run-backend:
	@echo "Starting backend services with Docker Compose..."
	cd backend && docker compose up

# Run frontend only
run-frontend:
	@echo "Starting frontend server..."
	cd frontend && pnpm run dev

# Build for production
build: build-backend build-frontend
	@echo "Build completed for both backend and frontend!"

build-backend:
	@echo "Building backend..."
	cd backend && poetry build

build-frontend:
	@echo "Building frontend..."
	cd frontend && pnpm run build

# Clean build artifacts and dependencies
clean:
	@echo "Cleaning build artifacts and dependencies..."
	cd backend && rm -rf dist/ .venv/ __pycache__/ *.egg-info/
	cd frontend && rm -rf .next/ node_modules/ dist/
	@echo "Clean completed!"

# Database operations (delegated to backend)
migrate:
	@echo "Running database migrations..."
	cd backend && poetry run python -m alembic upgrade head

refresh-db:
	@echo "Refreshing database..."
	cd backend && poetry run python -m alembic upgrade head

# Testing
test: test-backend test-frontend

test-backend:
	@echo "Running backend tests..."
	cd backend && $(MAKE) test

test-frontend:
	@echo "Running frontend tests..."
	cd frontend && npm run lint

# Docker operations
docker-build:
	@echo "Building Docker images with Docker Compose..."
	cd backend && docker compose build

docker-run:
	@echo "Running backend with Docker Compose..."
	cd backend && docker compose up

docker-run-build:
	@echo "Building and running backend with Docker Compose..."
	cd backend && docker compose up --build

docker-run-detached:
	@echo "Running backend with Docker Compose in detached mode..."
	cd backend && docker compose up -d

docker-stop:
	@echo "Stopping Docker Compose services..."
	cd backend && docker compose down

docker-logs:
	@echo "Showing Docker Compose logs..."
	cd backend && docker compose logs -f