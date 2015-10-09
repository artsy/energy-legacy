class ARLabSettingsNavigationController:UINavigationController {

    func exitSettingsPanel(){
        precondition(self.parentViewController is ARLabSettingsViewController, "Parent view controller must be an ARLabSettingsViewController")

        if let parent = self.parentViewController as? ARLabSettingsViewController {
            parent.exitSettingsPanel()
        }
    }

}