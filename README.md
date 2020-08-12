# Exercism v3 Local Environment

Hello 👋

This repository will provide you with a local setup of Exercism that you can use to develop any part of the project.

It requires the following to install:
- **[Docker](https://docs.docker.com/get-docker/):** Docker needs to be installed but no Docker knowledge is required. 
- **[Ruby](https://www.ruby-lang.org/en/documentation/installation/):** Many of the scripts in this repository are written in Ruby. Any version 2+ is fine. Without Ruby, you will have to create your `docker-compose.yml` manually.
- **Git:** In order to obtain this repository using the instructions below, you need `git` installed.

Our aim is to get you to a working setup within 10-minutes from now (presuming you have a decent internet connection).
It's also possible to get each piece of Exercism working on your local machine without this repository, but that will take lots more effort and work.

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
git clone git@github.com:exercism/v3-docker-compose.git

# Move into the new directory
cd v3-docker-compose

# Create your "stack" - the collection of parts of Exercism you
# want to run locally. For now simply copy the default file.
cp stack.default.yml stack.yml

# Start everything
./bin/start
```

### Updating everything

The first time `./bin/start` is run, it will download the latest versions of all the Exercism components for you to use.
When you want to upgrade those components, which we advise doing regularly, run:

```bash
docker-compose pull
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

### Shelling into a container

From time to time you may want to access a shell on a running container to run commands or check what is going on.
To access a shell into a running container you can use the provided `bin/shell` command.
For example, to shell into the running `website` container, you would run:

```bash
bin/shell website
```

### Stopping everything

To stop everything, run:
```
docker-compose down
```

## What is actually going on?

### Docker Compose

We are using [Docker Compose](https://docs.docker.com/compose/).
Compose is a tool for defining and running multi-container Docker applications.
With Compose, you use a YAML file to configure your application’s services.
Then, with a single command, you create and start all the services from your configuration.

In the context of Exercism, each component (e.g. the website UI, an analyzer, the code that manages test runners) has it's own Dockerfile.
These Dockerfiles are stored within each component's repository (often named `dev.Dockerfile`) and are built and pushed to DockerHub via GitHub Actions.

The code in this repository handles the creation of a `docker-compose.yml` and provides you with some wrapper scripts to run things.
The `bin/start` script generates the `docker-compose.yml` from your `stack.yml` file, downloads the images from DockerHub and then starts them (via `docker-compose up`).

### stack.yml

The `stack.yml` file is a Exercism-specific configuration file that allows you to select which components you want to run locally, and any configuration you want to do.
The `bin/start` script then takes that configuration and does the work of turning it into a `docker-compose.yml`.

Every docker image you download takes up storage space, and every docker container you run takes up memory, so the `stack.yml` file allows to you ensure that you only run the things that are necessary for whichever part of Exercism you are working on.

## Advanced Usage

### Working on certain components of the architecture

In order to working on a specific component of Exercism's architecture, you will need to have the relevant git repository downloaded locally.

Presuming you don't change the directory name from the repo name on GitHub, running `./bin/start` will mount the locally checked out repository in the Docker container.
This means any changes you make to the local filesystem are reflected within the Docker container.

For example, if you wanted to work on the `javascript-test-runner`, you might do the following:

```bash
# Start in your general Exercism directory (the first you made in the instructions above)
cd exercism

# Clone the relevant repository
git clone git@github.com:exercism/javascript-test-runner.git

# Move into the directory for *this* repo
cd v3-docker-compose

#
# Check the component is listed in the "enabled" section of your stack.yml.
#

# Run the bin/start command
./bin/start
```

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
docker-compose build tooling-invoker
```

You can then run `./bin/start` as normal.

Each time you change the Dockerfile or dependencies it mounts (e.g. the Gemfile), you will need to rerun the build and start commands.

## Stuck?

Stuck running the Docker setup? Please open an issue in this repository, and we will try and help you fix things, and tweak things so other people don't face the same challenge.

If you have an issue unrelated to this local Docker setup, please open an issue in the relevant repository (e.g. for the JavaScript Test Runner, use https://github.com/exercism/javascript-test-runner).
If you are unsure where to open the issue, please use https://github.com/exercism/exercism.

## Contributing to this repository

We welcome contributions! Please open an issue explaining the problem(s) you are facing, or put together a Pull Request demonstrating your idea or solution. Thank you!
