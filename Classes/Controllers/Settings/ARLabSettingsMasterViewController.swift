class ARLabSettingsMasterViewController:UIViewController {

    @IBOutlet weak var settingsButton: UIButton!

    override func viewDidLoad() {
        self.setupSettingsButton()
    }

    func setupSettingsButton() {
        if let image: UIImage! = UIImage(named: "settings_btn_whiteborder")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate) {
            self.settingsButton.setImage(image, forState: UIControlState.Normal)
            self.settingsButton.tintColor = UIColor.blackColor()
            self.settingsButton.backgroundColor = UIColor.whiteColor()
        }
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

@IBDesignable class ARAttributedLabel: UILabel {

    @IBInspectable var fontSize: CGFloat = 16.0

    @IBInspectable var fontFamily: String = "AGaramondPro-Regular"

    override func awakeFromNib() {
        let attrString = NSMutableAttributedString(attributedString: self.attributedText!)

        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: self.fontFamily, size: self.fontSize)!, range: NSMakeRange(0, attrString.length))

        self.attributedText = attrString
    }
}