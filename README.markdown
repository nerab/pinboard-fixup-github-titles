# Fixup titles of Pinboard-bookmarked github repos

The page titles that github produces suck. The repo's description is much more useful. This script walks through all your Pinboard bookmarks that point to a github repo and updates its title to be of the form:

    <project name>: <project description>

# Principle

* Fetch all pinboard bookmarks that point to github
* Build the canonical title from the github project title and its description
* Update the pinboard bookmark with the canonical title

# Usage

1. Set your github.com credentials in `.netrc` or any other of the ways supported by [octokit.rb](http://octokit.github.io/octokit.rb/#Authentication).

1. Get the API token from the Pinboard [password](https://pinboard.in/settings/password) page and set it as environment variable.

        $ export PINBOARD_API_TOKEN=********

1. Run the tool:

        $ pinboard-fixup-github-titles

The tool will read your github credentials from `netrc`.

# Docker Image

An automated build on the [docker hub](https://hub.docker.com/r/nerab/pinboard-fixup-github-titles/) creates a new image tagged with `latest` upon a git push.

Optionally, you can build the image manually:

    # Build and tag as the latest version of the image
    $ docker build --tag nerab/pinboard-fixup-github-titles:latest .

# Deployment

## Generate the run helper

* Install `lpass`
* Generate the deployment script `scripts/generate-deployment-script > scripts/run.sh`

If desired, you may run the container manually:

    $ docker run \
        --env PINBOARD_API_TOKEN=******** \
        --env GITHUB_ACCESS_TOKEN=******** \
        --name pinboard-fixup-github-titles \
        nerab/pinboard-fixup-github-titles

Change the environment variables to suit your preferences. The following environment variables are evaluated (in ascending order of preference):

1. `GITHUB_LOGIN` and `GITHUB_PASSWORD`
1. `GITHUB_ACCESS_TOKEN`
1. `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`
1. `NETRC_FILE` (not useful for docker deployments)

## Start the container

Run the previously generated `scripts/run.sh`. This will generate a new container from the image and execute the `pinboard-fixup-github-titles` tool once. The container will then stop.

In order to run the tool regularly, create a cron job that runs the container e.g. every hour:

    $ crontab -e
    36 * * * * docker start -a pinboard-fixup-github-titles

The environment variables were passed when running the container for the first time, so there is no need to pass them to `docker start` again.

A container will not print its console messages to where it was started from. If you want to follow the execution, use `docker logs`:

    $ docker logs -f pinboard-fixup-github-titles

## Update the container

```
docker pull nerab/pinboard-fixup-github-titles

# This will fail in most cases because the container is only running once an hour
docker stop nerab/pinboard-fixup-github-titles

docker rm nerab/pinboard-fixup-github-titles
./scripts/run.sh
```
