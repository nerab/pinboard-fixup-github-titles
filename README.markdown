# Fixup titles of Pinboard-bookmarked github repos

The page titles that github produces suck. The repo's description is much more useful. This script walks through all your Pinboard bookmarks that point to a github repo and updates its title to be of the form:

    <project name>: <project description>

# Principle

* Fetch all pinboard bookmarks that point to github
* Build the canonical title from the github project title and its description
* Update the pinboard bookmark with the canonical title

# Usage

Get the API token from the Pinboard [password](https://pinboard.in/settings/password) page, set it as environment variable and run the tool:

    $ PINBOARD_API_TOKEN=nerab:***** pinboard-fixup-github-titles
