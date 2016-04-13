warn("PR is classed as Work in Progress") if pr_title.include? "[WIP]"

# For the small PRs that are essentially README fixes etc
# you don't necessarily need to include a CHANGELOG
# Mark your PR as trivial!
declared_trivial = pr_title.include? "#trivial"

if modified_files.include?("docs/CHANGELOG.yml") == false && !declared_trivial
  fail("No CHANGELOG changes made")
end

# Stop skipping some manual testing
if lines_of_code > 50 && pr_title.include?("📱") == false
   warn("Needs testing on a Phone if change is non-trivial")
end

# Open for ideas on more
