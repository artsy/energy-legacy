import CoreData
//import SyncLog

class ARLabSettingsSyncViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lastSyncedTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!

    let viewModel = ARSyncStatusViewModel.init(sync: nil);

    override func viewDidLoad() {
        self.lastSyncedTableView.dataSource = self
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.syncLogCount()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("lastSyncedCell") as UITableViewCell!

        if let dates = self.viewModel.lastSyncedStrings() as? [String] {
            if let textLabel = cell.textLabel as UILabel! {
                textLabel.text = dates[indexPath.row]
                textLabel.font = UIFont.serifFontWithSize(15)
                textLabel.textColor = UIColor.artsyHeavyGrey()
            }
        }

        return cell
    }

    @IBAction func syncButtonPressed(sender: AnyObject) {
        self.viewModel.startSync()
        self.tableView.reloadData()
    }
}


/// http://stackoverflow.com/questions/25925914/attributed-string-with-custom-fonts-in-storyboard-does-not-load-correctly
@IBDesignable class ARAttributedLabel: UILabel {

    @IBInspectable var fontSize: CGFloat = 16.0

    @IBInspectable var fontFamily: String = "AGaramondPro-Regular"

    override func awakeFromNib() {
        let attrString = NSMutableAttributedString(attributedString: self.attributedText!)

        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: self.fontFamily, size: self.fontSize)!, range: NSMakeRange(0, attrString.length))

        self.attributedText = attrString
    }
}