//
//  ViewController.swift
//  FileSorter
//
//  Created by Paul Gowder on 2/9/19.
//  Copyright © 2019 Paul Gowder. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBAction func pickFilePressed(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.title = "choose file"
        dialog.showsResizeIndicator = true;
        dialog.showsHiddenFiles = true;
        dialog.canChooseDirectories = false;
        dialog.canCreateDirectories = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes = ["txt", "pdf"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if let path = result?.path {
                fileName.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    @IBOutlet var fileName: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

