//
//  CameraViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit
import SnapKit
import AVFoundation

final class CustomCameraViewController: BaseViewController<BaseView, CameraViewModel> {
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var previewContainerView: UIView!

    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
        setupUI()
        print(#function, self)
    }

    private func setupUI() {
        view.backgroundColor = .black

        setupPreviewView()
        setupOverlayView()
        setupShutterButton()
        setupTopControlButtons()
        setupZoomButton()
        setupGuideToggleButton()
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
        let overlayView = UIView()
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = true
        view.addSubview(overlayView)

        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 오버레이 이미지 뷰는 이 뷰의 서브뷰로 추가될 예정
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
            make.width.height.equalTo(70)
        }
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
            make.centerY.equalToSuperview().offset(200)
        }
    }
}
