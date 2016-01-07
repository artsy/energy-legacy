warn("PR is classed as Work in Progress") if pr_title.include? "[WIP]"

if files_modified.include?("docs/CHANGELOG.yml") == false
  fail("No CHANGELOG changes made")
end

# Stop skipping some manual testing
if lines_of_code > 50 && pr_title.include?("📱") == false
   warn("Needs testing on a Phone if change is non-trivial")
end

# Open for ideas on more