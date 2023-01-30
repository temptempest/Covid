//
//  SearchCountryCell.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit
import SnapKit

final class SearchCountryCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private lazy var selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.orange.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.theme.searchCountry.topLabel
        label.textColor = UIColor.theme.secondaryText
        label.textAlignment = .left
        return label
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leftImageView.image = UIImage()
        activityIndicatorView.startAnimating()
    }
    
    func configure(country: Country) {
        topLabel.text = country.country + " [\(country.iso2)]"
        if country.flag != nil {
            leftImageView.image = UIImage(data: country.flag.emptyDataIfEmpty)?
                .withRenderingMode(.alwaysOriginal)
                .imageByAddingBorder(width: 5, color: UIColor.theme.text)
            activityIndicatorView.stopAnimating()
        }
    }
    
    private func setupUI() {
        selectedBackgroundView = selectedView
        contentView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(contentView.snp.leading)
            $0.width.height.equalTo(70)
        }
        contentView.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(contentView.snp.leading)
            $0.width.height.equalTo(70)
        }
        contentView.addSubview(topLabel)
        topLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(leftImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        if leftImageView.image != nil {
            leftImageView.image = leftImageView.image?.imageByAddingBorder(width: 5, color: UIColor.theme.text)
        }
    }
}
