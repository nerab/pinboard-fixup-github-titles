* Stats in JSON format (after Stats class was inherited from pinboard-fixup-tweets)
* Limit the number of posts processed (see pinboard-fixup-tweets)
* Move to rspec
* If the URL ends with #something, remove it. Octokit gets confused by that: "https://github.com/sstephenson/bats#readme: Octokit::InvalidRepository - Invalid Repository. Use user/repo format."
* Handle Octokit::NotFound (mail the pinboard account owner, tag the bookmark as not found, or even delete the bookmark altogether)
