//
//  DocumentVC.swift
//  DownloadAndViewPDF
//
//  Created by Rijo Samuel on 16/01/22.
//

import UIKit
import PDFKit

final class DocumentVC: UIViewController {
	
	var pdfUrl: URL?
	
	private let pdfView: PDFView = {
		
		let pdfView = PDFView()
		return pdfView
	}()
	
    override func viewDidLoad() {
		
        super.viewDidLoad()
		title = "Document"
		view.addSubview(pdfView)
		
		guard let url = pdfUrl else { return }
		
		pdfView.document = PDFDocument(url: url)
    }
	
	override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		pdfView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
	}
}
