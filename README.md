**NOTE: This repository is part of Exercism v3 (launch target Q1 2021). It is not applicable for the current version of Exercism.**

---

# Exercism Development Environment

Hello! 👋 

This repository will provide you with Exercism's local development environment, which you can use to develop any part of the project.

Our aim is to get you to a working setup within 10 minutes from now, most of which will be spent downloading things, but if you have a slower internet connection, things may take longer.

It requires the following to install:
- **[Docker](https://docs.docker.com/get-docker/):** Docker needs to be installed but **no Docker knowledge is required** and you do not need a DockerHub account.
- **[Ruby](https://www.ruby-lang.org/en/documentation/installation/):** Many of the scripts in this repository are written in Ruby. Any version 2+ is fine. 
- **Git:** In order to obtain this repository using the instructions below, you need `git` installed.

**Windows users:** We recommend using [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10) and running the commands in a WSL-enabled terminal.

## Basic setup

The following instructions take you through getting the most basic setup working.
We'll explain what actually happens below the hood, and how to configure things afterwards.

### Getting set up

To start, run the following instructions line-by-line:

```bash
# Make a directory to host all of Exercism within
mkdir exercism

# Move into the new directory
cd exercism

# Clone this repository onto your computer
git clone git@github.com:exercism/development-environment.git

# Move into the new directory
cd development-environment

# Create your "stack" - the collection of parts of Exercism you
# want to run locally. To start with, copy the default file.
cp stack.default.yml stack.yml

# Start everything
./bin/start
```

### Updating everything

The first time `./bin/start` is run, it will download the latest versions of all the Exercism components for you to use.
If you want to download and run the latest version of those components — which we advise doing regularly — run:

```bash
./bin/start --pull
```

If you face any issues getting started, we recommend running this step in case anything is cached locally from a previous installation.

### Logs

Once the docker stack is running you can view the logs in real-time using:

```bash
docker-compose logs -f
```

You can watch the logs of a single component by specifying its name.
For example, to tail the `website` logs:

```bash
docker-compose logs -f website
```

It is also possible to have container logs be output to the console. To enable this, pass the `--tail` argument to `./bin/start`:

```bash
./bin/start --tail
```

### Shelling into a component

You may want to access a shell on a running component to run commands or check what is going on.
To access a shell on a running container you can use the provided `bin/shell` command.
For example, to shell into the running `website` container, you would run:

```bash
bin/shell website
```

### Stopping everything

To stop everything, run:

```bash
docker-compose stop
```

Alternatively, to stop everything _and_ remove all data (including the database storage), run:

```bash
docker-compose down
```

Details for restarting individual components are explained below.

## What is actually going on?

### Docker Compose

We are using [Docker Compose](https://docs.docker.com/compose/).
Compose is a tool for defining and running applications made up of multiple [Docker containers](https://www.docker.com/resources/what-container).
With Compose, you use a YAML file to configure your application’s services.
Then, with a single command, you create and start all the services from your configuration.

In the context of Exercism, each component (e.g. the website UI, an analyzer, the code that manages test runners) has it's own Dockerfile.
These Dockerfiles are stored within each component's repository (often named `dev.Dockerfile`) and are built and pushed to DockerHub via GitHub Actions.

The code in this repository handles the creation of a `docker-compose.yml` and provides you with some wrapper scripts to run things.
The `bin/start` script generates the `docker-compose.yml` from your `stack.yml` file, downloads the images from DockerHub and then starts them (via `docker-compose up`).

Note: Docker for Windows by default stores its data on the `C:` drive, but this can be changed in the settings.

### stack.yml

The `stack.yml` file is a Exercism-specific configuration file that allows you to select which components you want to run locally, and any configuration you want to do.
The `bin/start` script then takes that configuration and does the work of turning it into a `docker-compose.yml`.

Every Docker image you download takes up storage space, and every docker container you run takes up memory, so the `stack.yml` file allows to you ensure that you only run the things that are necessary for whichever part of Exercism you are working on.

## Advanced Usage

### Working on certain components of the architecture

In order to working on a specific component of Exercism's architecture, you will need to have the relevant git repository downloaded locally. For example, if you wanted to work on the `javascript-test-runner`, you might do the following:

```bash
# Start in your general Exercism directory (the first you made in the instructions above)
cd exercism

# Clone the relevant repository
git clone git@github.com:exercism/javascript-test-runner.git
```

The next step is to navigate to the `development-environment` directory:

```bash
# Move into the directory for *this* repo
cd development-environment
```

Now edit the `stack.yml` file to both enable the component and set its `source` configuration option to `true`:

```yaml
# stack.yml

enabled:
  - javascript-test-runner

configure:
  javascript-test-runner:
    source: true
```

Running `./bin/start` will now mount the locally checked out repository in the Docker container.
This means any changes you make to the local filesystem are reflected within the Docker container.

Depending on the reload-behaviour of the component you are working, you may need to restart the component after changes.
For example, the Website live-updates any changes made to the code as Rails applications and designed to do so, but the Tooling Invoker does not as it is a more simple Ruby application.
Restarting a component can be achieved by running a single command:

```bash
docker-compose restart tooling-invoker
```

### Manually building docker images

In more unusual situations you may need to (re)build the docker image from source, rather than using a pre-provided image.
This is especially true if you're planning on modifying the dependencies (local libraries, node modules, gems, dependencies, etc), as opposed to just changing source code.
Dependencies are usually "baked" into the images at build time.

To rebuild an image from source, edit the `stack.yml` to include a `build` section for the component you want to build from source.

For example, to have the tooling-invoker build from source rather than using an image:

```yaml
# stack.yml

configure:
  tooling-invoker:
    build: true
```

And then, to build it:

```bash
./bin/start --build
```

Each time you change the Dockerfile or dependencies it mounts (e.g. the Gemfile), you will need to rerun the start command with the `--build` flag.

## FAQs?

### Do I have to use this to work on Exercism?

No. 

If you want to only work on a language track, without seeing it running in context of the website, you can just directly work on that repository. In fact, that is the most common way to work on tracks.

Similarly if you want to work on tooling (test runners, analyzers, representers, etc) and you are happy to develop them in isolation, you do not need to use this repository. Although you may choose to to see your work running in the context of the website.

If you want to work on the various components of the website itself, then this is the official and only-supported way to work. However, you do not have to use it. You **can** set things up and get things playing nicely together locally, but this will probably be challenging, and unlikely to be worth the investment of your time. Instructions for each component can be found in the individual repositories, but we do not maintain instructions on how to piece them altogether.

## Stuck?

Stuck running the Docker setup? Please open an issue in this repository, and we will try and help you fix things, and tweak things so other people don't face the same challenge.

If you have an issue unrelated to this local Docker setup, please open an issue in the relevant repository (e.g. for the JavaScript Test Runner, use https://github.com/exercism/javascript-test-runner).
If you are unsure where to open the issue, please use https://github.com/exercism/exercism.

## Contributing to this repository

We welcome contributions! Please open an issue explaining the problem(s) you are facing, or put together a Pull Request demonstrating your idea or solution. Thank you!
