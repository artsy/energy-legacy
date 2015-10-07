  # Ensure our YAML CHANGELOG is up to snuff

  require 'yaml'
  puts "Validating CHANGELOG.yml"

  puts Dir.pwd
  readme_yaml = File.read("../docs/CHANGELOG.yml")
  readme_data = YAML.load(readme_yaml)

  unless readme_data["upcoming"]["version"]
    puts 'No new version found in ["upcoming"]["version"]'
    exit
  end

  last_release = readme_data["releases"][0]
  unless last_release["notes"] && last_release["version"] && last_release["date"]
    puts 'The most recent release does not have all three of "notes", "version" and "date".'
    exit
  end
