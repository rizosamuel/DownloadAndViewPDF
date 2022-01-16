//
//  PDFDownloader.swift
//  DownloadAndViewPDF
//
//  Created by Rijo Samuel on 16/01/22.
//

import Foundation

final class PDFDownloader: NSObject {
	
	static let shared = PDFDownloader()
	
	override private init() { }
	
	var callback: ((_ url: URL) -> Void)?
	
	func downloadPDF() {
		
		let urlString = "https://www.tutorialspoint.com/swift/swift_tutorial.pdf"
		let queue = OperationQueue()
		let session = URLSession(configuration: .default, delegate: self, delegateQueue: queue)
		
		guard let url = URL(string: urlString) else { return }
		
		let task = session.downloadTask(with: url)
		task.resume()
	}
}

// MARK: - URL Session Delegate Methods
extension PDFDownloader: URLSessionDownloadDelegate {
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		
		guard let url = downloadTask.originalRequest?.url else { return }
		
		let docPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
		let destinationPath = docPath.appendingPathComponent(url.lastPathComponent)
		
		try? FileManager.default.removeItem(at: destinationPath)
		
		do {
			try FileManager.default.copyItem(at: location, to: destinationPath)
			DispatchQueue.main.async { [weak self] in
				self?.callback?(destinationPath)
			}
		} catch {
			print(error.localizedDescription)
		}
	}
}
