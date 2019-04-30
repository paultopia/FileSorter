//
//  docxmerge.swift
//  FileSorter
//
//  Created by Paul Gowder on 4/30/19.
//  Copyright © 2019 Paul Gowder. All rights reserved.
//

import AppKit

func readDocx(_ infile: URL) -> NSAttributedString {
    let data = NSData(contentsOf: infile)
    let str = try! NSAttributedString(data: data! as Data, options: [.documentType: NSAttributedString.DocumentType.officeOpenXML, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    return str
}

func readMutableDocx(_ infile: URL) -> NSMutableAttributedString {
    let data = NSData(contentsOf: infile)
    let str = try! NSMutableAttributedString(data: data! as Data, options: [.documentType: NSAttributedString.DocumentType.officeOpenXML, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    return str
}

func makeDocxMerge(_ docs: [URL]) -> NSMutableAttributedString {
    let first = readMutableDocx(docs[0])
    let rest = docs[1...]
    let lineBreaks = NSAttributedString(string: "\n\n")
    for docToAdd in rest {
        first.append(lineBreaks)
        first.append(readDocx(docToAdd))
    }
    return first
}

func toDocx(_ str: NSAttributedString) -> Data {
    let range = NSMakeRange(0, str.length)
    let out = try! str.data(from: range, documentAttributes: [.documentType: NSAttributedString.DocumentType.officeOpenXML])
    return out
}

func mergeDocxs(files: [URL]) -> Data {
    let docdata = makeDocxMerge(files)
    let docx = toDocx(docdata)
    return docx
}

// needs error handling.  right now it just forces everything.  not good.
