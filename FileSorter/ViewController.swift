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
    var fileType = "pdf"
    
    // helper function for shuffling arrays around
    func moveOver<Item>(_ arr: [Item], start: Int, dest: Int) -> [Item] {
        var out = arr
        let rem = out.remove(at: start)
        out.insert(rem, at: dest)
        return out
    }
    
    
    @IBOutlet var typeSwitcher: NSSegmentedControl!
    
    
    @IBAction func typeSwitcherPressed(_ sender: Any) {
        switch typeSwitcher!.selectedSegment {
        case 0:
            fileType = "pdf"
        case 1:
            fileType = "docx"
        default:
            break;
        }
    }
    
    private var dragDropType = NSPasteboard.PasteboardType(rawValue: "private.table-row")
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var statusField: NSTextField!
    @IBOutlet var mergeButton: NSButton!
    @IBAction func removeButtonPressed(_ sender: Any) {
        guard (tableView.selectedRow >= 0) else {
            return
        }
        filesList.remove(at: tableView.selectedRow)
        tableView.reloadData()
        if (filesList.count < 2){
            mergeButton.isEnabled = false
            statusField.stringValue = Status.waiting.rawValue
        }
    }
    @IBAction func clearButtonPressed(_ sender: Any) {
        filesList = []
        tableView.reloadData()
        statusField.stringValue = Status.waiting.rawValue
        mergeButton.isEnabled = false
    }
    @IBAction func pickFilePressed(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.title = "choose file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = true
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = true
        dialog.allowedFileTypes = [fileType]
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let results = dialog.urls
            filesList.append(contentsOf: results)
            tableView.reloadData()
            if (filesList.count >= 2){
                statusField.stringValue = Status.ready.rawValue
                mergeButton.isEnabled = true
            } else {
                statusField.stringValue = Status.waiting.rawValue
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    @IBAction func mergeButtonPressed(_ sender: Any) {
        let dialog = NSSavePanel()
        dialog.title = "choose destination"
        dialog.showsResizeIndicator = true;
        dialog.showsHiddenFiles = true;
        dialog.canCreateDirectories = true;
        dialog.allowedFileTypes = [fileType];
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let dest = dialog.url {
                let result = doMerge(files: filesList, outfile: dest, type: fileType)
                if result {
                    filesList = []
                    tableView.reloadData()
                    statusField.stringValue = Status.success.rawValue
                    mergeButton.isEnabled = false
                }
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
        tableView.registerForDraggedTypes([dragDropType])
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
        text = item.lastPathComponent
        cellIdentifier = CellIdentifiers.NameCell
    }
    
    if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
        cell.textField?.stringValue = text
        return cell
    }
    return nil
    }
}

extension ViewController {
    
    // borrowed from https://stackoverflow.com/a/52368491/4386239 with some mods
    
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        
        let item = NSPasteboardItem()
        item.setString(String(row), forType: self.dragDropType)
        return item
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        
        if dropOperation == .above {
            return .move
        }
        return []
    }
    
    func reorderFilesList(start: [Int], dest: Int){
        let from = start[0]
        var to = dest
        if dest > from {
            to -= 1
        }
        filesList = moveOver(filesList, start: from, dest: to)
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        
        var oldIndexes = [Int]()
        info.enumerateDraggingItems(options: [], for: tableView, classes: [NSPasteboardItem.self], searchOptions: [:]) { dragItem, _, _ in
            if let str = (dragItem.item as! NSPasteboardItem).string(forType: self.dragDropType), let index = Int(str) {
                oldIndexes.append(index)
            }
        }
        
        var oldIndexOffset = 0
        var newIndexOffset = 0
        
        reorderFilesList(start: oldIndexes, dest: row)
    /*
        checking code for getting file sort right.  Can be removed later.
        print(oldIndexes)
        print(row)
        print(filesList)
    */
        tableView.beginUpdates()
        for oldIndex in oldIndexes {
            if oldIndex < row {
                tableView.moveRow(at: oldIndex + oldIndexOffset, to: row - 1)
                oldIndexOffset -= 1
            } else {
                tableView.moveRow(at: oldIndex, to: row + newIndexOffset)
                newIndexOffset += 1
            }
        }
        tableView.endUpdates()
        
        return true
    }
    
}
