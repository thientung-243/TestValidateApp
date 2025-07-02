//
//  DownloadManager.swift
//  TestValidateApp
//
//  Created by Thien Tung on 1/7/25.
//

import Foundation

class DownloadManager: NSObject {
    
    // MARK: Reference
    static let shared = DownloadManager()
    
    // MARK: Properties
    private var downloadTasks: [URL: URLSessionDownloadTask] = [:]
    private var videos: [Video] = []
    var onProgressUpdate: ((URL, Float) -> Void)?
    var onDownloadComplete: ((Video) -> Void)?
    var onDownloadError: ((Video, Error) -> Void)?

    //MARK: Functions
    func getVideos() -> [Video] {
        return videos
    }
    
    func getVideosDownloading() -> [Video] {
        return videos.filter({ !$0.isDownloaded })
    }
    
    func downloadVideo(from url: URL) {
        let fileName = url.lastPathComponent
        let destinationURL = FileManager.default.getDocumentsDirectory().appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            if let existingVideo = videos.first(where: { $0.url == url }) {
                onDownloadError?(existingVideo, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Video đã được tải xuống"]))
            } else {
                let video = Video(url: url, fileName: fileName, isDownloaded: true)
                videos.append(video)
                onDownloadError?(video, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Video đã được tải xuống"]))
            }
            return
        }
        
        if let existingVideo = videos.first(where: { $0.url == url }) {
            if existingVideo.isDownloaded {
                onDownloadError?(existingVideo, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Video đã được tải xuống"]))
                return
            }
            return
        }
        
        let video = Video(url: url, fileName: fileName, isDownloaded: false)
        videos.append(video)
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let task = session.downloadTask(with: url)
        downloadTasks[url] = task
        task.resume()
    }
    
    func cancelDownload(for url: URL) {
        if let task = downloadTasks[url] {
            task.cancel()
            downloadTasks.removeValue(forKey: url)
            if let index = videos.firstIndex(where: { $0.url == url }) {
                videos.remove(at: index)
            }
        }
    }
}

extension DownloadManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let fileName = url.lastPathComponent
        let destinationURL = FileManager.default.getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            try FileManager.default.moveItem(at: location, to: destinationURL)
            if let index = videos.firstIndex(where: { $0.url == url }) {
                videos[index].isDownloaded = true
                onDownloadComplete?(videos[index])
            }
            downloadTasks.removeValue(forKey: url)
        } catch {
            if let index = videos.firstIndex(where: { $0.url == url }) {
                onDownloadError?(videos[index], error)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        onProgressUpdate?(url, progress)
    }
}
