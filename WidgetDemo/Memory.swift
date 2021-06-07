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

class RequestBackground {
    let url: URL
    init(url: URL) {
        self.url = url
    }
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "MySession")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config)
    }()
    
    func request() {
        let backgroundTask = urlSession.downloadTask(with: url)
        backgroundTask.earliestBeginDate = Date().addingTimeInterval(60 * 60)
        backgroundTask.countOfBytesClientExpectsToSend = 200
        backgroundTask.countOfBytesClientExpectsToReceive = 500 * 1024
        backgroundTask.resume()
    }
}
