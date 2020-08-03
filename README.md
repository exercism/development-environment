# Exercism v3 Local Environment

This provides a local environment for running Exercism on Docker. It is very much a WIP.

## Local setup

Run the following line-by-line.

```bash
# Make a directory to host all of Exercism within
mkdir exercism

# cd into it
cd exercism

# Clone this repo
git clone git@github.com:exercism/v3-docker-compose.git

# Clone the essential repos
git clone git@github.com:exercism/config.git
git clone git@github.com:exercism/v3-website.git
git clone git@github.com:exercism/tooling-orchestrator.git
git clone git@github.com:exercism/tooling-invoker.git

# You also temporarily need the csharp test runner
git clone git@github.com:exercism/csharp-test-runner.git

# Build everything in parallel
cd v3-docker-compose
docker-compose build --parallel

# This is your normal starting command
docker-compose up --build
```
