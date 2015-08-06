#!/usr/bin/env ruby

readme = File.read("Docs/CHANGELOG.md")
beta_readme = File.read("Docs/BETA_CHANGELOG.md")

mini_readme = readme.split("\n## ")[0..1].join("\n## ")
generated_changelog = beta_readme + "\n\n-------\n" + mini_readme

File.open("CHANGELOG_SHORT.md", 'w') { |f| f.write(generated_changelog) }
