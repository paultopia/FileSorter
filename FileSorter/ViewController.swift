//
//  ViewController.swift
//  FileSorter
//
//  Created by Paul Gowder on 2/9/19.
//  Copyright © 2019 Paul Gowder. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var filesList: [URL] = []
    @IBOutlet var tableView: NSTableView!
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
            if let result = dialog.url {
            filesList.append(result)
            print(filesList)
            fileName.stringValue = result.path
            tableView.reloadData()
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    @IBOutlet var fileName: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filesList.count
    }
    
}

extension ViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCellID"
}
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    var text: String = ""
    var cellIdentifier: String = ""
    
    let item = filesList[row]
    
    if tableColumn == tableView.tableColumns[0] {
        text = item.path
        cellIdentifier = CellIdentifiers.NameCell
    }
    
    if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
        cell.textField?.stringValue = text
        return cell
    }
    return nil
    }
}

