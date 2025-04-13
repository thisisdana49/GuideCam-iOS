//  SettingsViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/10/25.
//

import UIKit

final class SettingsViewController: UIViewController {

    private let tableView = UITableView()
    private let settings: [SettingItem] = [
        .privacyPolicy
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "설정"
        view.backgroundColor = .black
        setupTableView()
        setupVersionLabel()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupVersionLabel() {
        let versionLabel = UILabel()
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.font = .systemFont(ofSize: 14)
        versionLabel.textColor = .gray
        versionLabel.textAlignment = .center

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "버전 정보: v\(version)"
        } else {
            versionLabel.text = "버전 정보"
        }

        view.addSubview(versionLabel)

        NSLayoutConstraint.activate([
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = settings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = settings[indexPath.row]
        switch item {
        case .privacyPolicy:
            if let url = URL(string: "https://mint-cupcake-e59.notion.site/1d08b1cac4d280dabf74c0c272e5db16?pvs=4") {
                let safariVC = UINavigationController(rootViewController: UIViewController())
                UIApplication.shared.open(url)
            }
        }
    }
}

private enum SettingItem {
    case privacyPolicy

    var title: String {
        switch self {
        case .privacyPolicy: return "개인정보처리방침"
        }
    }
}
