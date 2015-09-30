import CoreData

class ARLabSettingsSyncViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lastSyncedTableView: UITableView!

    override func viewDidLoad() {
        self.lastSyncedTableView.dataSource = self
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return syncLogCount()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lastSyncedCell") as UITableViewCell!
        cell.textLabel?.text = "November 17, 1992 at 5:00am"
        return cell
    }

    func syncLogCount() -> NSInteger {
        let request:NSFetchRequest = NSFetchRequest(entityName: "SyncLog")
        request.sortDescriptors = [NSSortDescriptor(key:"dateStarted", ascending: true)]
        return CoreDataManager.mainManagedObjectContext().countForFetchRequest(request, error: nil)
    }

}