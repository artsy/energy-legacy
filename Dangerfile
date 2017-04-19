warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# For the small PRs that are essentially README fixes etc
# you don't necessarily need to include a CHANGELOG
# Mark your PR as trivial!
declared_trivial = github.pr_title.include? "#trivial"

if git.modified_files.include?("docs/CHANGELOG.yml") == false && !declared_trivial
  fail("No CHANGELOG changes made")
end

# Stop skipping some manual testing
if git.lines_of_code > 50 && github.pr_title.include?("📱") == false
  warn("Needs testing on a Phone if change is non-trivial")
end

# CHANGELOG should lint
begin
  require 'yaml'
  readme_yaml = File.read "docs/CHANGELOG.yml"
  readme_data = YAML.load readme_yaml
rescue StandardError
  fail("CHANGELOG isn't legit YAML")
end


# Use Circle's build artifacts feature to let Danger read the build, and test logs.
# There's nothing fancy here, just a unix command chain with `tee` sending the output to a known file.
#
test_file = File.join(ENV["CIRCLE_ARTIFACTS"], "xcode_test_raw.log")

# If there's snapshot fails, we should also fail danger, but we can make the thing clickable in a comment instead of hidden in the log
# Note: this _may_ break in a future build of Danger, I am debating sandboxing the runner from ENV vars.
test_log = File.read test_file
snapshots_url = test_log.match(%r{https://eigen-ci.s3.amazonaws.com/\d+/index.html})
fail("There were [snapshot errors](#{snapshots_url})") if snapshots_url

# Look for unstubbed networking requests in the build log, as these can be a source of test flakiness.
unstubbed_regex = /   Inside Test: -\[(\w+) (\w+)/m
if test_log.match(unstubbed_regex)
  output = "#### Found unstubbed networking requests\n"
  test_log.scan(unstubbed_regex).each do |class_and_test|
    class_name = class_and_test[0]
    url = "https://github.com/search?q=#{class_name.gsub("Spec", "")}+repo%3Aartsy%2Feigen&ref=searchresults&type=Code&utf8=✓"
    output += "\n* [#{class_name}](#{url}) in `#{class_and_test[1]}`"
  end
  warn(output)
end
