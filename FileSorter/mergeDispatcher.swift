//
//  mergeDispatcher.swift
//  FileSorter
//
//  Created by Paul Gowder on 4/30/19.
//  Copyright © 2019 Paul Gowder. All rights reserved.
//

import Foundation

public func doMerge(files: [URL], outfile: URL, type: String) -> Bool {
    switch type {
    case "pdf":
        guard let merged = try? mergePDFs(files: files) else {
            print("failed")
            return false
        }
        merged.write(to: outfile)
        print("Success! Merged \(files) into \(outfile)!")
        return true
    case "docx":
        let merged = mergeDocxs(files: files)
        // CURRENTLY HAS NO ERROR HANDLING.  FIX THIS.
        try! merged.write(to: outfile)
        print("Success! Merged \(files) into \(outfile)! BUT: need to do error handling.")
        return true
    default:
        print("What else do you want, bro?")
        return false
    }

}

