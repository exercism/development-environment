# Getting the development environment set up

## What your directory should look like

```text
<root>
├── development-environment
├── <Any other v3 repos you may be working with>
└── v3-website
```

## Git workflow to working from a fork

### Cloning `exercism/v3-website` and maintaining your `fork`

```text
> cd <root>
> git clone https://github.com/exercism/v3-website.git
> cd v3-website
```

After a pull request is open against `exercism/v3-website`, the remote fork's branch can be checked out [following this guide][github-mod-inactive-pr-local].  After making a commit, you can't `git push` to the `exercism`'s repo, but you can to your own fork

```text
> git push <remote-name> HEAD:<remote-branch-name>
```

### Using your own fork

```text
> cd <root>
> git clone <your v3-website fork> v3-website 
```

Then when making commits you can easily push the commit to the origin

## Running tests

Now when you start the development environment, it will use your `v3-website` repo as the source for the rails application. When the development environment is running, enter the website's running docker container to run tests.

```text
> docker exec -it development-environment_website_1 bash
> bundle exec rails test # run all rails tests
> yarn test [<specific test file>] # run jest tests
```

[github-mod-inactive-pr-local]: https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/checking-out-pull-requests-locally#modifying-an-inactive-pull-request-locally
