//
//  Memory.swift
//  WidgetAppDemo
//
//  Created by Tri Dang on 24/05/2021.
//

import Foundation

struct Memory {
    var a = Date()
    var totalDiskSpaceInBytes: Int64 {
        do {
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
            let diskSpace = space! / 1048576
            return diskSpace
        } catch {
            return 0
        }
    }

    var freeDiskSpaceInBytes: Int64 {
        do {
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            let space = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
            let freeSpace = space! / 1048576
            return freeSpace
        } catch {
            return 0
        }
    }

    var usedDiskSpaceInBytes: Int64 {
        let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
        return usedSpace
    }
}
