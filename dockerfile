# Use a Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set the working directory
WORKDIR C:/actions-runner

# Install required dependencies
RUN powershell -Command \
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; \
    # Install Git
    Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.39.1.windows.2/MinGit-2.39.1-64-bit.zip -OutFile git.zip; \
    Expand-Archive -Path git.zip -DestinationPath C:/ProgramData/MinGit; \
    Remove-Item -Force git.zip; \    
    [System.Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\ProgramData\MinGit\cmd', [System.EnvironmentVariableTarget]::Machine); \
    # Install the GitHub Actions runner
    Invoke-WebRequest -Uri https://github.com/actions/virtual-environments/releases/download/2.288.0/windows-latest-2024-09-13-01.tar.gz -OutFile runner.tar.gz; \
    tar -xvf runner.tar.gz;

# Copy the registration script into the container
COPY ./start-runner.ps1 C:/actions-runner/start-runner.ps1

# Make the entrypoint the start script to register and run the runner
ENTRYPOINT ["powershell", "C:/actions-runner/start-runner.ps1"]

# Expose the necessary ports (optional)
EXPOSE 8080
