# Ensure that the required environment variables are set
if (-not $env:GITHUB_TOKEN) {
    Write-Host "Error: GITHUB_TOKEN environment variable is not set"
    exit 1
}

if (-not $env:GITHUB_REPOSITORY) {
    Write-Host "Error: GITHUB_REPOSITORY environment variable is not set"
    exit 1
}

# Define the GitHub URL (repository or organization)
$repositoryUrl = "https://github.com/$env:GITHUB_REPOSITORY"

# Configure the runner using the token and repository
Write-Host "Registering runner with GitHub repository: $repositoryUrl"
& "C:/actions-runner/config.cmd" --url $repositoryUrl --token $env:GITHUB_TOKEN

# Start the runner service to listen for jobs
Write-Host "Starting GitHub Actions runner..."
& "C:/actions-runner/run.cmd"
