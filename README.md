# Exercism v3 

## Local setup

Run the following line-by-line. 

```
# Make a directory to host all of Exercism within
mkdir exercism

# cd into it
cd exercism

# Clone this repo
git clone git@github.com:exercism/v3-docker-compose.git

# Clone the essential repos
git clone git@github.com:exercism/v3-website.git
git clone git@github.com:exercism/tooling-orchestrator.git
git clone git@github.com:exercism/tooling-invoker.git

# Warm the cache (Optional - see note below)

# This varies by OS/shell
pushd v3-website
mkdir cache
BUNDLE_PATH=cache/bundler bundle install
echo "--modules-folder cache/node_modules" > .yarnrc
echo "--cache-folder cache/yarn" >> .yarnrc
yarn install
rm .yarnrc
popd

pushd tooling-invoker
mkdir cache
BUNDLE_PATH=cache/bundler bundle install
ln -s cache/bundler cache/bundler
popd

pushd tooling-orchestrator
mkdir cache
BUNDLE_PATH=cache/bundler bundle install
popd

# Build everything in parallel
cd v3-docker-compose
docker-compose build --parallel

# This is your normal starting command
docker-compose up --build
```

### Warm the cache

Installing the dependencies is slow. 
In the container build it's slow due to native compilation. 
Because changing the Gemfile.lock invalidates that image layer, the cache is removed meaning we then have to recompile all those things again.
Inside the container it's too slow to build the gems and cache locally due to IO limitations. 

The commands listed above warm the cache by installing the dependencies once before the docker build and then providing them to the container. 
This step is **optional** but will save you significant time in the long-run.
They can be run regularly, whenever the Gemfile.lock changes.

#### Ruby

When running the commands, please ensure you are using **Ruby 2.6.x**.
This is probably most easily installed via [ruby-install](https://github.com/postmodern/ruby-install):
```
ruby-install ruby 2.6
```

Other Ruby installation options are avaliable on the [ruby-lang website](https://www.ruby-lang.org/en/documentation/installation/).

#### JavaScript

You probably also need some sort of JavaScript/Node but I have no idea how any of that works - so someone might want to update this PR with instructions... :)
