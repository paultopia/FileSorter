//
//  pdfmerge.swift
//  FileSorter
//
//  Created by Paul Gowder on 2/10/19.
//  Copyright © 2019 Paul Gowder. All rights reserved.
//

import Foundation
import Quartz

public enum PDFMergeError: Error {
    case cannotOpenFile(filename: String)
    case fileNotValidPDF(filename: String)
    case justOneInputFile
}

func openPDF(_ file: URL) throws -> PDFDocument {
    guard let pdata = try? NSData(contentsOf: file) as Data else {
        throw PDFMergeError.cannotOpenFile(filename: file.path)
    }
    guard let pdf = PDFDocument(data: pdata) else {
        throw PDFMergeError.fileNotValidPDF(filename: file.path)
    }
    return pdf
}

public func mergePDFs(files: [URL]) throws -> PDFDocument {
    if files.count == 1 {
        throw PDFMergeError.justOneInputFile
    }
    let first = files[0]
    let rest = files[1...]
    let pdf = try openPDF(first)
    var curpagenum = pdf.pageCount
    var cur2add: PDFDocument
    var curpage: PDFPage
    var lenOfCurAdd: Int
    for p2add in rest {
        cur2add = try openPDF(p2add)
        lenOfCurAdd = cur2add.pageCount
        for i in 0..<lenOfCurAdd {
            curpage = cur2add.page(at: i)!
            pdf.insert(curpage, at: curpagenum)
            curpagenum+=1
        }
    }
    return pdf
}

func fileExists(_ filename: URL) -> Bool {
    let fileManager = FileManager()
    return fileManager.fileExists(atPath: filename.path)
}

public func doMerge(files: [URL], outfile: URL) -> Bool {
    guard let merged = try? mergePDFs(files: files) else {
        print("failed")
        return false
    }
    merged.write(to: outfile)
    print("Success! Merged \(files) into \(outfile)!")
    return true
}
