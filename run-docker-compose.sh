#!/usr/bin/env bash

set -e  # Exit on error

# Script to run all docker-compose files in the repository
# This script reads environment variables from .env file and manages docker compose services

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/.env"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Print usage information
print_usage() {
    cat << EOF
Usage: $0 [COMMAND] [OPTIONS]

Commands:
    up          Start all docker compose services (default)
    down        Stop all docker compose services
    restart     Restart all docker compose services
    status      Show status of all docker compose services
    logs        Show logs from all docker compose services
    pull        Pull latest images for all services

Options:
    -h, --help  Show this help message

Examples:
    $0 up       # Start all services
    $0 down     # Stop all services
    $0 logs     # View logs from all services
EOF
}

# Check if docker is installed
check_docker() {
    log_info "Checking Docker installation..."
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    log_success "Docker is installed"
}

# Load environment variables from .env file
load_env_file() {
    if [ -f "$ENV_FILE" ]; then
        log_info "Loading environment variables from $ENV_FILE"
        # Export variables from .env file
        set -a
        source "$ENV_FILE"
        set +a
        log_success "Environment variables loaded successfully"
    else
        log_warning ".env file not found at $ENV_FILE"
        log_info "You can create one by copying .env.example: cp .env.example .env"
    fi
}

# Find all docker-compose files in the repository
find_compose_files() {
    log_info "Searching for docker-compose files in $SCRIPT_DIR" >&2
    
    # Find all docker-compose.yml and docker-compose.yaml files
    local compose_files=()
    while IFS= read -r -d '' file; do
        compose_files+=("$file")
        log_info "Found docker-compose file: $file" >&2
    done < <(find "$SCRIPT_DIR" -type f \( -name "docker-compose.yml" -o -name "docker-compose.yaml" \) -print0 2>/dev/null)
    
    if [ ${#compose_files[@]} -eq 0 ]; then
        log_warning "No docker-compose files found in the repository" >&2
        return 1
    fi
    
    log_success "Found ${#compose_files[@]} docker-compose file(s)" >&2
    printf '%s\n' "${compose_files[@]}"
}

# Run docker compose command on a specific file
run_compose_command() {
    local compose_file="$1"
    local command="$2"
    local compose_dir="$(dirname "$compose_file")"
    local compose_name="$(basename "$compose_dir")"
    
    log_info "Running 'docker compose $command' for $compose_name (file: $compose_file)"
    
    cd "$compose_dir"
    
    case "$command" in
        up)
            if docker compose -f "$(basename "$compose_file")" up -d; then
                log_success "Successfully started services in $compose_name"
            else
                log_error "Failed to start services in $compose_name"
                return 1
            fi
            ;;
        down)
            if docker compose -f "$(basename "$compose_file")" down; then
                log_success "Successfully stopped services in $compose_name"
            else
                log_error "Failed to stop services in $compose_name"
                return 1
            fi
            ;;
        restart)
            if docker compose -f "$(basename "$compose_file")" restart; then
                log_success "Successfully restarted services in $compose_name"
            else
                log_error "Failed to restart services in $compose_name"
                return 1
            fi
            ;;
        pull)
            if docker compose -f "$(basename "$compose_file")" pull; then
                log_success "Successfully pulled images for $compose_name"
            else
                log_error "Failed to pull images for $compose_name"
                return 1
            fi
            ;;
        logs)
            log_info "Showing logs for $compose_name"
            docker compose -f "$(basename "$compose_file")" logs --tail=50
            ;;
        status|ps)
            log_info "Status for $compose_name:"
            docker compose -f "$(basename "$compose_file")" ps
            ;;
        *)
            log_error "Unknown command: $command"
            return 1
            ;;
    esac
    
    cd "$SCRIPT_DIR"
}

# Main function
main() {
    local command="${1:-up}"
    
    # Parse arguments
    case "$command" in
        -h|--help)
            print_usage
            exit 0
            ;;
        up|down|restart|status|logs|pull)
            # Valid command
            ;;
        *)
            log_error "Unknown command: $command"
            print_usage
            exit 1
            ;;
    esac
    
    log_info "=== Docker Compose Runner for n8n-server ==="
    log_info "Command: $command"
    
    # Check prerequisites
    check_docker
    
    # Load environment variables
    load_env_file
    
    # Find all compose files
    local compose_files=()
    while IFS= read -r file; do
        compose_files+=("$file")
    done < <(find_compose_files)
    
    if [ ${#compose_files[@]} -eq 0 ]; then
        log_error "No docker-compose files found. Exiting."
        exit 1
    fi
    
    # Execute command on all compose files
    log_info "Executing '$command' command on all docker-compose files..."
    local failed=0
    
    for compose_file in "${compose_files[@]}"; do
        if ! run_compose_command "$compose_file" "$command"; then
            ((failed++))
        fi
        echo ""  # Add blank line for readability
    done
    
    # Summary
    echo ""
    log_info "=== Summary ==="
    log_info "Total compose files processed: ${#compose_files[@]}"
    
    if [ $failed -eq 0 ]; then
        log_success "All operations completed successfully!"
        exit 0
    else
        log_error "$failed operation(s) failed"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
