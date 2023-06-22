//
//  UIImageView+URL.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 22/06/23.
//

import UIKit
import Foundation

struct ImageDownload {
    let dataTask: URLSessionDataTask
    let url: URL
}

enum ImageError : Error {
    case missingData
    case dataNotImage
}

extension UIImageView {
    
    private static var dataTaskKey: UInt8 = 0
    private static var imageCache = NSCache<NSURL,UIImage>()
    
    private var download: ImageDownload? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.dataTaskKey) as? ImageDownload
        } set {
            objc_setAssociatedObject(self, &UIImageView.dataTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func setImage(_ image: UIImage?, error: Error?, url: URL) {
        DispatchQueue.main.async {
            if let image = image {
                UIImageView.imageCache.setObject(image, forKey: url as NSURL)
            }
            guard self.download?.url == url else { return }
            // We were still waiting for this image
            // TODO: Broken jpg or the like, for now just set the image to nil
            self.image = image
            self.download = nil
        }
    }
    
    func setImageWithURL(_ url: URL) {
        if let download = download {
            if download.url == url {
                // Already downloading this image
                return
            }
            // Technically we could allow this task to continue to cache the image but for now we'll just cancel
            download.dataTask.cancel()
        }
        if let image = UIImageView.imageCache.object(forKey: url as NSURL) {
            self.image = image
            return
        }
        // Have to download the image clear it out while we wait
        image = nil
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let self = self else { return }
            if let error = error, case URLError.cancelled = error {
                if case URLError.cancelled = error {
                    return
                }
                self.setImage(nil, error: error, url: url)
                return
            }
            guard let data = data else {
                self.setImage(nil, error: ImageError.missingData, url: url)
                return
            }
            
            guard let image = UIImage(data: data) else {
                self.setImage(nil, error: ImageError.dataNotImage, url: url)
                return
            }
            self.setImage(image, error: nil, url: url)
        }
        download = ImageDownload(dataTask: task, url: url)
        task.resume()
    }
    
    // WORK IN PROGRESS OPTIMIZATION
    // If two image views look for the same URL back to back the above code would download it twice
    // Trying to see if I can work out a download at most once solution
    // Seems to be working fine with the limited data set, as such I left it connected
    // Prints "The optimization caught a download" when it exits earlier than the other approach would exit
    private static var waitingImageViews = [URL:Set<UIImageView>]()
    private static var downloadTasks = [URL: URLSessionDataTask]()
    private static var urlKey: UInt8 = 0
    private var url: URL? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL
        } set {
            objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func setOptimizedImage(_ image: UIImage?, error: Error?, url: URL) {
        DispatchQueue.main.async {
            if let image = image {
                UIImageView.imageCache.setObject(image, forKey: url as NSURL)
            }
            UIImageView.downloadTasks.removeValue(forKey: url)
            guard let waitingImageViews = UIImageView.waitingImageViews[url] else { return }
            for imageView in waitingImageViews {
                guard imageView.url == url else { continue }
                // We were still waiting for this image
                // TODO: Broken jpg or the like, for now just set the image to nil
                imageView.image = image
                imageView.url = nil
            }
            UIImageView.waitingImageViews.removeValue(forKey: url)
        }
    }
    
    func setImageFromURL(_ url: URL) {
        if let currentURL = self.url {
            if currentURL == url {
                // Already waiting for this image
                return
            }
            self.url = nil
            if var waitingImageViews = UIImageView.waitingImageViews[currentURL] {
                waitingImageViews.remove(self)
                UIImageView.waitingImageViews[url] = waitingImageViews
            }
        }
        if let image = UIImageView.imageCache.object(forKey: url as NSURL) {
            self.image = image
            return
        }
        
        // Have to download the image clear it out while we wait
        image = nil
        
        defer {
            self.url = url
            var waitingImageViews = UIImageView.waitingImageViews[url] ?? Set<UIImageView>()
            waitingImageViews.insert(self)
            UIImageView.waitingImageViews[url] = waitingImageViews
        }
        
        if UIImageView.downloadTasks[url] != nil {
            // Already downloading this image, let the defer put us in line to get it
            print("The optimization caught a download")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let self = self else { return }
            if let error = error, case URLError.cancelled = error {
                if case URLError.cancelled = error {
                    return
                }
                self.setOptimizedImage(nil, error: error, url: url)
                return
            }
            guard let data = data else {
                self.setOptimizedImage(nil, error: ImageError.missingData, url: url)
                return
            }
            guard let image = UIImage(data: data) else {
                self.setOptimizedImage(nil, error: ImageError.dataNotImage, url: url)
                return
            }
            self.setOptimizedImage(image, error: nil, url: url)
        }
        UIImageView.downloadTasks[url] = task
        task.resume()
    }
    
    
}
