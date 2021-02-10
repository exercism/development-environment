# Getting the development environment set up

## What your directory should look like

```text
<root>
├── development-environment
├── <Any other v3 repos you may be working with>
└── website
```

## Git workflow to working from a fork

### Cloning `exercism/website` and maintaining your `fork`

```text
> cd <root>
> git clone https://github.com/exercism/website.git
> cd website
```

After a pull request is opened against `exercism/website`, the remote fork's branch can be checked out [following this guide][github-mod-inactive-pr-local]. After making a commit, you can't `git push` to the `exercism`'s repo, but you can to your own fork.

```text
> git push <remote-name> HEAD:<remote-branch-name>
```

### Using your own fork

```text
> cd <root>
> git clone <your website fork> website
```

Then when making commits you can easily push the commit to the origin (your fork).

## Running tests

Now when you start the development environment, it will use your `website` repo as the source for the rails application. When the development environment is running, enter the website's running docker container to run tests.

```text
# Open a terminal to the running website container:
> ./bin/shell website

# You can alternatively use:
> docker exec -it development-environment_website_1 bash

> bundle exec rails test # run all rails tests
> yarn test [<specific test file>] # run jest tests
```

If you don't need a persistent terminal in the container, you can also use these commands:

```text
> ./bin/script website run-js-tests         # Run the jest tests
> ./bin/script website run-tests            # Run the Rails tests
> ./bin/script website run-system-tests     # Run the Capybara tests
```

[github-mod-inactive-pr-local]: https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/checking-out-pull-requests-locally#modifying-an-inactive-pull-request-locally
