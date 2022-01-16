//
//  ViewController.swift
//  DownloadAndViewPDF
//
//  Created by Rijo Samuel on 16/01/22.
//

import UIKit

final class MainVC: UIViewController {
	
	private var pdfUrl: URL?
	
	private let btnDownload: UIButton = {
		
		let button = UIButton()
		button.setTitle("Download PDF", for: .normal)
		button.setTitleColor(.systemBackground, for: .normal)
		button.backgroundColor = .label
		button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private let btnOpen: UIButton = {
		
		let button = UIButton()
		button.setTitle("Open PDF", for: .normal)
		button.setTitleColor(.label, for: .normal)
		button.backgroundColor = .systemRed
		button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private let loadingIndicator: UIActivityIndicatorView = {
		
		let indicator = UIActivityIndicatorView(style: .large)
		indicator.translatesAutoresizingMaskIntoConstraints = false
		indicator.color = .systemOrange
		return indicator
	}()
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "Home"
		view.backgroundColor = .systemBackground
		view.addSubview(btnDownload)
		view.addSubview(btnOpen)
		view.addSubview(loadingIndicator)
		
		btnOpen.isEnabled = false
		
		btnDownload.addTarget(self, action: #selector(didTapBtnDownload), for: .touchUpInside)
		btnOpen.addTarget(self, action: #selector(didTapBtnOpen), for: .touchUpInside)
		
		configureConstraints()
	}
	
	override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		btnDownload.layer.cornerRadius = btnDownload.frame.size.height / 2
		btnOpen.layer.cornerRadius = btnOpen.frame.size.height / 2
	}
	
	@objc private func didTapBtnDownload() {
		
		loadingIndicator.startAnimating()
		btnDownload.isEnabled = false
		btnOpen.isEnabled = false
		
		PDFDownloader.shared.downloadPDF()
		
		PDFDownloader.shared.callback = { [weak self] pdfUrl in
			
			self?.loadingIndicator.stopAnimating()
			self?.pdfUrl = pdfUrl
			self?.btnOpen.isEnabled = true
			self?.btnDownload.isEnabled = true
		}
	}
	
	@objc private func didTapBtnOpen() {
		
		guard let url = pdfUrl else { return }
		
		let documentVC = DocumentVC()
		documentVC.pdfUrl = url
		present(documentVC, animated: true, completion: nil)
	}
	
	private func configureConstraints() {
		
		let btnDownloadConstraints = [
			btnDownload.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			btnDownload.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		]
		
		let btnOpenConstraints = [
			btnOpen.topAnchor.constraint(equalTo: btnDownload.bottomAnchor, constant: 20),
			btnOpen.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			btnOpen.widthAnchor.constraint(equalTo: btnDownload.widthAnchor)
		]
		
		let loadingIndicatorConstraints = [
			loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			loadingIndicator.heightAnchor.constraint(equalToConstant: 50),
			loadingIndicator.widthAnchor.constraint(equalToConstant: 50)
		]
		
		NSLayoutConstraint.activate(btnDownloadConstraints)
		NSLayoutConstraint.activate(btnOpenConstraints)
		NSLayoutConstraint.activate(loadingIndicatorConstraints)
	}
}
