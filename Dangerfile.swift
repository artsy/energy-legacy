// Want to improve this file?
// run `swift run danger-swift edit` in the terminal
// and it will pop open in Xcode

import Danger
import Foundation
import Yams

let danger = Danger()

// This one runs on Travis CI
// There is another on Circle which validates the tests
let modified = danger.git.modifiedFiles
let editedFiles = modified + danger.git.createdFiles
message("These files have changed: \(editedFiles.joined(separator: ", "))")
let testFiles = editedFiles.filter { $0.contains("Tests") && ($0.fileType == .swift  || $0.fileType == .m) }

// Validates that we've not accidentally let in a testing
// shortcut to simplify dev work
let testingShortcuts = ["fdescribe", "fit(@", "fit("]
for file in testFiles {
    let content = danger.utils.readFile(file)
    for shortcut in testingShortcuts {
        if content.contains(shortcut) {
            fail(message: "Found a testing shortcut", file: file, line: 0)
        }
    }
}

// Highlight snapshot fails
let logs = danger.utils.readFile("./xcode_test_raw.log")
let regex = try NSRegularExpression(pattern: "https://eigen-ci.s3.amazonaws.com/\\d+/index.html")
let matches = regex.matches(in: logs, options: [], range: NSMakeRange(0, logs.count))
if matches.count > 0 {
    fail("There were [snapshot errors](\(matches.first!)})")
}

// Ensure the CHANGELOG is set up like we need
do {
    let changelogYML = danger.utils.readFile("CHANGELOG.yml")
    try Yams.load(yaml: changelogYML)
} catch {
    fail("The CHANGELOG is not valid YML")
}
