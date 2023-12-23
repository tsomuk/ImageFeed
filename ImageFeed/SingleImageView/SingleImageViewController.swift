//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 30.07.2023.
//

import UIKit


final class SingleImageViewController : UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var imageView : UIImageView!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            guard let image else { return }
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    private var alertPresenter: AlertPresenting?
    var largeImageURL: URL?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        imageView.image = image
        setupScrollView()
        downloadImage()
        guard let image else { return }
        rescaleAndCenterImageInScrollView(image: image)
    }
   
   
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sharingButtonTapped(_ sender: UIButton) {
        guard let image = image else { return }
              let activityController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(activityController, animated: true, completion: nil)
    }
    
    func setupScrollView() {
      scrollView.minimumZoomScale = 0.1
      scrollView.maximumZoomScale = 1.25
    }
       
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
      let scaleImageMin = scrollView.minimumZoomScale
      let scaleImageMax = scrollView.maximumZoomScale

      view.layoutIfNeeded()
      let visibleContentSize = scrollView.bounds.size
      let imageSize = image.size
      let scaleHeight = visibleContentSize.height / imageSize.height
      let scaleWidth = visibleContentSize.width / imageSize.width
      let scaleImageTemp = max(scaleWidth, scaleHeight)
      let scaleImage = min(scaleImageMax, max(scaleImageMin, scaleImageTemp))
      scrollView.setZoomScale(scaleImage, animated: false)
      scrollView.layoutIfNeeded()

      let newContentSize = scrollView.contentSize
      let imageOffsetX = (newContentSize.width - visibleContentSize.width) / 2
      let imageOffsetY = (newContentSize.height - visibleContentSize.height) / 2
      scrollView.setContentOffset(CGPoint(x: imageOffsetX, y: imageOffsetY), animated: false)
      scrollView.layoutIfNeeded()
        
        
    }
    
    func downloadImage() {
      UIBlockingProgressHUD.show()
      imageView.kf.setImage(with: largeImageURL) { [weak self] result in
        UIBlockingProgressHUD.dismiss()
        guard let self else { return }
        switch result {
        case .success(let imageResult):
          self.image = imageResult.image
          self.rescaleAndCenterImageInScrollView(image: imageResult.image)
        case .failure:
          showError()
        }
      }
    }
    
    func showError() {
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        let alertModel = AlertModel(
          title: "Что-то пошло не так",
          message: "Попробовать ещё раз?",
          buttonText: "Не надо",
          completion: { self.dismiss(animated: true) },
          secondButtonText: "Повторить",
          secondCompletion: { self.downloadImage() }
        )
        self.alertPresenter?.showAlert(for: alertModel)
      }
    }
    
}

extension SingleImageViewController : UIScrollViewDelegate  {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
