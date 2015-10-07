  # Ensure no deploys with OSS keys

  require 'cocoapods-core'
  puts "Validating CocoaPods Keys"
  Dir.chdir ".." do
    podfile = Pod::Podfile.from_file "Podfile"
    target = podfile.plugins["cocoapods-keys"]["target"] || ""
    podfile.plugins["cocoapods-keys"]["keys"].each do |key|
      puts " - #{key}"

        value = `bundle exec pod keys get #{key} #{target}`
        value = value.split("]").last.strip

      if value == "-" || value == "" || value == "3a33d2085cbd1176153f99781bbce7c6" || value == "e750db60ac506978fc70"
        puts "Did not pass validation for key #{key}."
        puts "Run `bundle exec pod keys get #{key} #{target}` to see what it is."
        puts "It's likely this is running with OSS keys."
        exit()
      end
    end
  end
