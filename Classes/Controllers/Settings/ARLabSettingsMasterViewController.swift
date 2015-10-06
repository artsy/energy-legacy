import KVOController

class ARLabSettingsMasterViewController:UIViewController {

    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var syncNotificationImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSettingsButton()
        self.updateSyncNotificationImage()
    }

    func setupSettingsButton() {
        guard let image: UIImage! = UIImage(named: "settings_btn_whiteborder")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate) else { return }
        self.settingsButton.setImage(image, forState: UIControlState.Normal)
        self.settingsButton.tintColor = UIColor.blackColor()
        self.settingsButton.backgroundColor = UIColor.whiteColor()
    }

    func updateSyncNotificationImage() {
        let cmsChecker = ARCMSStatusMonitor.init(context: CoreDataManager.mainManagedObjectContext())
        cmsChecker.checkCMSForUpdates({ (shouldShowSyncImage) -> Void in
                self.syncNotificationImageView.hidden = !shouldShowSyncImage
            })
    }

    @IBAction func settingsButtonPressed(sender: AnyObject) {
        self.exitSettingsPanel()
    }

    @IBAction func ogSettingsButtonPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: AROptionsUseLabSettings)
        self.exitSettingsPanel()
    }

    @IBAction func editPresentationModeButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("presentationModeSegue", sender: self)
    }
    
    @IBAction func syncButtonPressed(sender: AnyObject) {
        self.syncNotificationImageView.hidden = true
        self.performSegueWithIdentifier("syncOptionsSegue", sender: self)
    }

    func exitSettingsPanel() {
        precondition(self.navigationController is ARLabSettingsNavigationController, "Navigation controller must be an ARLabSettingsNavigationController")

        if let navController = self.navigationController as? ARLabSettingsNavigationController {
            navController.exitSettingsPanel()
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}