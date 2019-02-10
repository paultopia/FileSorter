//
//  statuses.swift
//  FileSorter
//
//  Created by Paul Gowder on 2/10/19.
//  Copyright © 2019 Paul Gowder. All rights reserved.
//

enum Status: String {
    case ready = "Status: ready to merge."
    case waiting = "Status: add at least two files to merge them."
    case success = "Status: success! Add more files to merge again."
}
