# Exercism v3 Local Environment

This provides a local environment for running Exercism on Docker. It is very much a WIP.

## Getting Started

Run the following line-by-line.

```bash
# Make a directory to host all of Exercism within
mkdir exercism

# cd into it
cd exercism

# Clone this repo
git clone git@github.com:exercism/v3-docker-compose.git

# Clone any essential repos you plan to hack on
git clone git@github.com:exercism/v3-website.git
git clone git@github.com:exercism/tooling-orchestrator.git
git clone git@github.com:exercism/tooling-invoker.git
git clone git@github.com:exercism/csharp-test-runner.git

cd v3-docker-compose

# edit stack.yml to enabled the services (runners, analyzers, you'll be using)
# Configure your custom Exercism stack
./bin/configure

# Build everything in parallel
docker-compose build --parallel

# This is your normal starting command
docker-compose up --build
```

## Hacking on certain components of the architecture

In order to hack on specific pieces of the architecture you'll need to fetch those from Git.  Say to work on tooling invoker.

```bash
# Again, this is the directory you're hosting all of Exercism repos within
cd exercism
git clone git@github.com:exercism/tooling-invoker.git
cd v3-docker-compose
```

You may need to edit `stack.yml` to build a custom Docker image of the service you are hacking on.  This is especially true if you're planning on modifying the dependencies (yarn, gems, etc) and not just the service source code. Dependencies are usually "baked" into the images at build time.

```yaml
configure:
  tooling-invoker:
    build: true
```

And finally to build it:

```bash
docker-compose build tooling-invoker
```