//
//  GuideSelectionCell.swift
//  GuideCam
//
//  Created by 조다은 on 4/10/25.
//

import UIKit
import SnapKit

final class GuideSelectionCell: UICollectionViewCell {

    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
        configureStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with guide: Guide) {
        if let transparentImage = GuideFileManager.shared.loadImage(from: guide.thumbnailPath) {
            thumbnailImageView.image = transparentImage.withBackgroundColor(.white)
        }
        titleLabel.text = guide.title
    }

    private func setupViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
    }

    private func setupLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(thumbnailImageView.snp.width)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func configureStyle() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.layer.borderColor = UIColor.white.cgColor
        thumbnailImageView.layer.borderWidth = 1

        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
    }

    func updateSelectedState(_ isSelected: Bool) {
        thumbnailImageView.layer.borderWidth = isSelected ? 2 : 1
        thumbnailImageView.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.white.cgColor
    }
}
