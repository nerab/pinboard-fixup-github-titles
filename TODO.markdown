* If the URL ends with #something, remove it. Octokit gets confused by that: "https://github.com/sstephenson/bats#readme: Octokit::InvalidRepository - Invalid Repository. Use user/repo format."
* Handle Octokit::NotFound (mail the pinboard account owner, tag the bookmark as not found, or even delete the bookmark altogether)
