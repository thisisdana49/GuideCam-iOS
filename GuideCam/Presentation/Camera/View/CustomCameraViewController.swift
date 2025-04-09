//
//  CameraViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit
import SnapKit
import AVFoundation
import Photos

private enum FlashMode: CaseIterable {
    case auto, on, off

    var icon: UIImage? {
        switch self {
        case .auto: return UIImage(systemName: "bolt.badge.a.fill")
        case .on: return UIImage(systemName: "bolt.fill")
        case .off: return UIImage(systemName: "bolt.slash.fill")
        }
    }

    var avFlashMode: AVCaptureDevice.FlashMode {
        switch self {
        case .auto: return .auto
        case .on: return .on
        case .off: return .off
        }
    }
}

final class CustomCameraViewController: BaseViewController<BaseView, CameraViewModel> {
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var previewContainerView: UIView!
    private var permissionRequiredView: UIView?
    private var photoOutput: AVCapturePhotoOutput?
    
    private var overlayContainerView: UIView! // Added property
    private var isGuideVisible = true // Added property

    private var zoomButton: UIButton!
    private var guideToggleButton: UIButton!
    private var shutterButton: UIButton!
    private var guideSelectButton: UIButton!

    private let zoomLevels: [CGFloat] = [1.0, 2.0, 3.0] // Added zoom state tracking
//    private let zoomLevels: [CGFloat] = [1.0, 2.0, 3.0, 0.5] // Added zoom state tracking
    private var currentZoomIndex = 0 // Added zoom state tracking
    
    // Flash
    private var currentFlashMode: FlashMode = .auto
    private var flashButton: UIButton!

    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
        checkCameraPermission { granted in
            if granted {
                self.setupUI()
            } else {
                self.showPermissionRequiredUI()
            }
        }
        print(#function, self)
    }

    @objc private func flashButtonTapped() {
        let allModes = FlashMode.allCases
        if let currentIndex = allModes.firstIndex(of: currentFlashMode) {
            let nextIndex = (currentIndex + 1) % allModes.count
            currentFlashMode = allModes[nextIndex]
        }
        flashButton.setImage(currentFlashMode.icon, for: .normal)
    }

    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }

    private func showPermissionRequiredUI() {
        let container = UIView()
        container.backgroundColor = .black
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let label = UILabel()
        label.text = "카메라 권한이 필요합니다.\n설정에서 권한을 허용해주세요."
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        let button = UIButton(type: .system)
        button.setTitle("설정으로 이동", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(openAppSettings), for: .touchUpInside)

        container.addSubview(label)
        container.addSubview(button)

        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(20)
        }

        self.permissionRequiredView = container
    }

    @objc private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    private func setupUI() {
        view.backgroundColor = .black

        setupPreviewView()
        setupOverlayView()
        setupShutterButton()
        setupTopControlButtons()
        setupZoomButton()
        setupGuideToggleButton()
        setupGuideSelectionButton()
    }

    private func setupPreviewView() {
        previewContainerView = UIView()
        previewContainerView.backgroundColor = .black
        view.addSubview(previewContainerView)

        previewContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        setupCameraSession()
    }

    private func setupCameraSession() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            print("❌ 카메라 입력 설정 실패")
            return
        }

        session.addInput(input)

        let output = AVCapturePhotoOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            self.photoOutput = output
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewContainerView.layer.addSublayer(previewLayer)
        previewLayer.frame = UIScreen.main.bounds

        self.captureSession = session
        self.previewLayer = previewLayer

        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }

    private func setupOverlayView() {
        overlayContainerView = UIView() // Updated to keep a reference
        overlayContainerView.backgroundColor = .clear
        overlayContainerView.isUserInteractionEnabled = false
        view.addSubview(overlayContainerView)

        overlayContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupShutterButton() {
        let shutterButton = UIButton()
        shutterButton.backgroundColor = .white
        shutterButton.layer.cornerRadius = 35
        shutterButton.layer.borderWidth = 4
        shutterButton.layer.borderColor = UIColor.lightGray.cgColor

        view.addSubview(shutterButton)

        shutterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(60)
            make.width.height.equalTo(70)
        }
        
        shutterButton.addTarget(self, action: #selector(shutterButtonTapped), for: .touchUpInside)
        self.shutterButton = shutterButton
    }

    @objc private func shutterButtonTapped() {
        guard let output = photoOutput else { return }
        let settings = AVCapturePhotoSettings()
        settings.flashMode = currentFlashMode.avFlashMode
        output.capturePhoto(with: settings, delegate: self)
        
        // 진동 피드백
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }

    private func setupTopControlButtons() {
        let topStackView = UIStackView()
        topStackView.axis = .horizontal
        topStackView.spacing = 20
        topStackView.alignment = .center
        topStackView.distribution = .equalSpacing

        let flashButton = UIButton()
        flashButton.setImage(UIImage(systemName: "bolt.badge.a"), for: .normal)
        flashButton.tintColor = .white
        flashButton.addTarget(self, action: #selector(flashButtonTapped), for: .touchUpInside)
        self.flashButton = flashButton

        let timerButton = UIButton()
        timerButton.setImage(UIImage(systemName: "timer"), for: .normal)
        timerButton.tintColor = .white

        let aspectButton = UIButton()
        aspectButton.setTitle("4:3", for: .normal)
        aspectButton.setTitleColor(.white, for: .normal)

        let switchButton = UIButton()
        switchButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        switchButton.tintColor = .white

        [flashButton, timerButton, aspectButton, switchButton].forEach {
            topStackView.addArrangedSubview($0)
        }

        view.addSubview(topStackView)
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
    }

    private func setupZoomButton() {
        let zoomButton = UIButton()
        zoomButton.setTitle("1.0x", for: .normal)
        zoomButton.setTitleColor(.white, for: .normal)
        zoomButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        zoomButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        zoomButton.layer.cornerRadius = 14
        zoomButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        view.addSubview(zoomButton)
        zoomButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(140)
        }
        
        zoomButton.addTarget(self, action: #selector(zoomButtonTapped), for: .touchUpInside) // Connected zoom action
        self.zoomButton = zoomButton
    }

    @objc private func zoomButtonTapped() { // Added zoom handler method
        currentZoomIndex = (currentZoomIndex + 1) % zoomLevels.count
        let zoomFactor = zoomLevels[currentZoomIndex]
        zoomButton.setTitle("\(zoomFactor)x", for: .normal)
        applyZoom(factor: zoomFactor)
    }

    private func applyZoom(factor: CGFloat) { // Added zoom logic
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        do {
            try device.lockForConfiguration()
            let clampedFactor = min(max(factor, device.minAvailableVideoZoomFactor), device.maxAvailableVideoZoomFactor)
            device.videoZoomFactor = clampedFactor
            device.unlockForConfiguration()
        } catch {
            print("❌ 줌 설정 실패: \(error.localizedDescription)")
        }
    }

    private func setupGuideToggleButton() {
        let guideToggle = UIButton()
        guideToggle.setTitle("가이드 OFF", for: .normal)
        guideToggle.setTitleColor(.white, for: .normal)
        guideToggle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        guideToggle.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        guideToggle.layer.cornerRadius = 14
        guideToggle.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)

        view.addSubview(guideToggle)
        guideToggle.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(140)
        }
        
        guideToggle.addTarget(self, action: #selector(toggleGuideOverlay), for: .touchUpInside) // Added toggle action
        self.guideToggleButton = guideToggle
    }

    @objc private func toggleGuideOverlay() { // Added toggle handler method
        isGuideVisible.toggle()
        overlayContainerView.isHidden = !isGuideVisible
        let title = isGuideVisible ? "가이드 OFF" : "가이드 ON"
        guideToggleButton.setTitle(title, for: .normal)
    }

    private func setupGuideSelectionButton() {
        let selectButton = UIButton(type: .system)
        selectButton.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        selectButton.tintColor = .white
        selectButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        selectButton.layer.cornerRadius = 20
        selectButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        selectButton.addTarget(self, action: #selector(presentGuideSelection), for: .touchUpInside)

        view.addSubview(selectButton)
        selectButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.centerX).offset(70)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(60)
            make.width.height.equalTo(40)
        }
        
        self.guideSelectButton = selectButton
    }

    @objc private func presentGuideSelection() {
        setBottomControlsHidden(true)

        let guideVC = GuideSelectionViewController(viewModel: GuideSelectionViewModel())
        guideVC.onGuideSelected = { [weak self] selectedGuide in
            self?.setBottomControlsHidden(false)
            if let image = GuideFileManager.shared.loadImage(from: selectedGuide.thumbnailPath) { // Added to apply overlay image
                self?.applyOverlayImage(image)
            }
        }
        let nav = UINavigationController(rootViewController: guideVC)
        nav.modalPresentationStyle = .pageSheet
        nav.presentationController?.delegate = self
        nav.isModalInPresentation = false
        nav.presentationController?.presentedViewController.isModalInPresentation = false

        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }

        present(nav, animated: true)
    }

    private func applyOverlayImage(_ image: UIImage) { // New method
        overlayContainerView.subviews.forEach { $0.removeFromSuperview() }

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.5
        overlayContainerView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func savePhotoToAlbum(_ image: UIImage) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

        switch status {
        case .authorized, .limited:
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    } else {
                        self.presentPhotoAccessDeniedAlert()
                    }
                }
            }

        case .denied, .restricted:
            presentPhotoAccessDeniedAlert()

        @unknown default:
            presentPhotoAccessDeniedAlert()
        }
    }

    private func presentPhotoAccessDeniedAlert() {
        let alert = UIAlertController(
            title: "사진 저장 권한이 필요해요",
            message: "설정에서 사진 권한을 허용해야 앨범에 저장할 수 있어요.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })

        present(alert, animated: true)
    }

    private func setBottomControlsHidden(_ hidden: Bool) {
        zoomButton?.isHidden = hidden
        guideToggleButton?.isHidden = hidden
        shutterButton?.isHidden = hidden
        guideSelectButton?.isHidden = hidden
    }
}

extension CustomCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("❌ 사진 촬영 실패: \(error!.localizedDescription)")
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("⚠️ 이미지 변환 실패")
            return
        }

        print("✅ 사진 촬영 성공: \(image.size)")

        // 사진을 앨범에 저장
        savePhotoToAlbum(image)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("❌ 사진 저장 실패: \(error.localizedDescription)")
        } else {
            print("✅ 사진이 앨범에 저장되었습니다.")
        }
    }
}

extension CustomCameraViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        setBottomControlsHidden(false)
    }
}
