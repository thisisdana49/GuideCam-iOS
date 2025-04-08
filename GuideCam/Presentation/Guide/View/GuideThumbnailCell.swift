//  GuideThumbnailCell.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit
import SnapKit

final class GuideThumbnailCell: UICollectionViewCell {

    private let guideImageView = UIImageView()
    private let titleLabel = UILabel()
    private let favoriteButton = UIButton()
    private let tagLabel = UILabel()

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
        print("***ThumnailPath,", guide.thumbnailPath)
        guideImageView.image = GuideFileManager.shared.loadImage(from: guide.thumbnailPath)
        titleLabel.text = guide.title
        favoriteButton.setImage(guide.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = guide.isFavorite ? .yellow : .lightGray
        tagLabel.isHidden = !guide.isRecent
    }

    private func setupViews() {
        contentView.addSubview(guideImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(tagLabel)
    }

    private func setupLayout() {
        guideImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(guideImageView.snp.width)
        }

        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(guideImageView).offset(8)
            $0.trailing.equalTo(guideImageView).inset(8)
            $0.width.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(guideImageView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }

        tagLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview()
        }
    }

    private func configureStyle() {
        guideImageView.contentMode = .scaleAspectFit
        guideImageView.layer.borderColor = UIColor.white.cgColor
        guideImageView.layer.borderWidth = 1

        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left

        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .lightGray

        tagLabel.font = .systemFont(ofSize: 10, weight: .bold)
        tagLabel.textColor = .black
        tagLabel.backgroundColor = .yellow
        tagLabel.layer.cornerRadius = 8
        tagLabel.clipsToBounds = true
        tagLabel.text = "Recent"
        tagLabel.textAlignment = .center
        tagLabel.isHidden = true
    }
    
    func updateSelectedState(_ isSelected: Bool) {
        print(#function)
        layer.borderWidth = isSelected ? 2 : 0
        layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.clear.cgColor
    }
    
}
