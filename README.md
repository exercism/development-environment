# Exercism v3 Local Environment

Hello 👋

This repository will provide you with a local setup of Exercise that you can use to develop any part of the project.

It is built using [Docker](https://www.docker.com/), which you need to install, but it does not require any real Docker knowledge to use.

Our aim is to get you to a working setup within 10-minutes from now (presuming you have a decent internet connection).
It's also possible to get each piece of Exercism working on your local machine without this repository, but that will take lots more effort and work.

## Basic setup

The following instructions take you through getting the most basic setup working.
We'll explain what actually happens below the hood, and how to configure things afterwards

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
# want to run locally. For now just copy the default file.
cp stack.default.yml stack.yml

# Start everything
./bin/start
```

If you have previously installed any of Exercism's components, you might also need (or want) to update them. You can do this with:

```bash
docker-compose pull
```

### Logs

Once the docker stack is running you can tail the logs using:

```bash
docker-compose logs -f
```

You can also tail just one component by specifying its name.
For example, to tail the website logs:

```bash
docker-compose logs -f website
```

### Shelling into a container

From time to time you may want to shell into a running container to run commands or check what is going on.
To shell into a running container you can use the provided `bin/shell` command.
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
These Dockerfiles are stored within the repositories (often named `dev.Dockerfile`) and are built and pushed to DockerHub via GitHub Actions.

The code in this repository handles the creation of a `docker-compose.yml` and provides you with some simple wrapper scripts to run things.
The `bin/start` script generates the `docker-compose.yml` from your `stack.yml` file, downloads the images from DockerHub and then starts them (via `docker-compose up`).

### stack.yml

The `stack.yml` file is a Exercism-specific configuration file that allows you to select which components you want to run locally, and any configuration you want to do.
We then take that configuration and do the hard-work of turning that into a `docker-compose.yml`.

Every docker image you download takes up HDD space, and every docker container you run takes up memory, so the `stack.yml` file allows to you ensure that you only run the things that are necessary for whichever part of Exercism you are working on.

## Advanced Usage

### Working on certain components of the architecture

In order to working on a specific component of Exercism's architecture, you will need to have the relevant git repository downloaded locally.

Presuming you don't change the directory name from the repo name on GitHub, running `./bin/start` will mount the locally checked out repository in the Docker container.
This means any changes you make to the local filesystem are reflected within the Docker container.

For example, if you wanted to work on the javascript-test-runner, you might do the following:

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
For example, the Website live-updates any changes made to the code (because Rails), but the Tooling Invoker does not.
Restarting a component is as simple as:

```bash
docker-compose restart tooling-invoker
```

### Manually bulding docker images

In more unusual situations you may need to rebuild the docker image from source, rather than using a pre-provided image.
This is especially true if you're planning on modifying the dependencies (local libraries, yarn, gems, etc), as opposed to just changing source code.
Dependencies are usually "baked" into the images at build time.

To achieve this, edit the `stack.yml` to include a `build` section for the component you want to build from source.

For example, to have the tooling-invoker build from source rather than an image:

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

