//
//  AppDelegate.swift
//  JETWOMAN
//
//  Created by Богдан Беннер on 09.08.2022.
//


import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
	@IBAction func resetHighScoreClicked(_ sender: Any) {
		UserDefaults.standard.set(0, forKey: "highScore")
		UserDefaults.standard.synchronize()
		if let VC = NSApplication.shared.windows.first?.contentViewController as? ViewController {
			if let scene = VC.skView.scene as? GameScene {
				scene.updateHighScore()
			}
		}
	}
	
}
