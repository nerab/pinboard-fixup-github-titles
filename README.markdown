# Fixup titles of Pinboard-bookmarked github repos

The page titles that github produces suck. The repo's description is much more useful. This script walks through all your Pinboard bookmarks that point to a github repo and updates its title to be of the form:

    <project name>: <project description>

# Principle

* Fetch all pinboard bookmarks that point to github
* Build the canonical title from the github project title and its description
* Update the pinboard bookmark with the canonical title

# Usage

1. Set your github.com credentials in `.netrc` (preferred) or any other of the ways supported by [octokit.rb](http://octokit.github.io/octokit.rb/#Authentication).

1. Get the API token from the Pinboard [password](https://pinboard.in/settings/password) page and set (or pass) it as environment variable.

1. Run the tool:

    $ PINBOARD_API_TOKEN=******** pinboard-fixup-github-titles

The tool will read your github credentials from `netrc`.

# Deployment

## Build a container from the image

    # Build and tag as the latest version of the image
    $ docker build --tag nerab/pinboard-fixup-github-titles:latest .

## Instantiate the container

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

After executing the `pinboard-fixup-github-titles` tool once, the container will stop.

## Start the container

Now create a cron job that runs the container on a regular basis:

    $ docker start pinboard-fixup-github-titles

The environment variables were passed when running the container for the first time, so there is no need to pass them at start again.

Starting a container will not print its console messages. If you want to follow the execution, use `docker logs`:

    $ docker logs -f pinboard-fixup-github-titles
