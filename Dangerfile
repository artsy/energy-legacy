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