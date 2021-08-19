//
//  AppearanceViewController.swift
//  USScienceNewsFeed
//
//  Created by gunta.golde on 19/08/2021.
//

import UIKit

class AppearanceViewController: UIViewController {
    
    @IBOutlet weak var appearanceTextLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsButton.layer.cornerRadius = 7
        setLabelText()
    }
    
    @IBAction func openSettingsTapped(_ sender: Any) {
        openSettings()
    }
    
    func setLabelText(){
        var text = "Unable to specify UI style"
        if self.traitCollection.userInterfaceStyle == .dark{
            text = "Dark Mode is On.\nGo to Settings if you\n would like to change to\n Light Mode."
        }else{
            text = "Light Mode is On.\nGo to Settings if you\n would like to change to\n Dark Mode."
        }
        appearanceTextLabel.text = text
    }
    
    func openSettings(){
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingURL){
            UIApplication.shared.open(settingURL, options: [:]) { success in
                print("sucess: ", success)
            }
        }
    }
}

extension AppearanceViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setLabelText()
    }
}
