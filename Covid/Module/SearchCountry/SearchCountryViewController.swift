//
//  SearchCountryViewController.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit
import SnapKit

final class SearchCountryViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    private typealias UserDataSource = UITableViewDiffableDataSource<Section, Country>
    private typealias CountrySnapshot = NSDiffableDataSourceSnapshot<Section, Country>
    private var dataSource: UserDataSource?
    private var countries: [Country] = []
    private var filteredCountries: [Country] = []
    
    var viewModel: SearchCountryViewModelDelegate? {
        didSet {
            viewModel?.updateHandler = { [weak self] countries in
                self?.countries = countries
                self?.filteredCountries = countries
                if self?.searchViewController.isActive == false {
                    OperationQueue.mainAsyncIfNeeded {
                        self?.perform(.updateDataSource(countries))
                    }
                }
            }
            viewModel?.updateFilteredHandler = { [weak self] filteredCountries in
                self?.filteredCountries = filteredCountries
                OperationQueue.mainAsyncIfNeeded {
                    self?.perform(.updateDataSource(filteredCountries))
                }
            }
            viewModel?.updateAlertHandler = { [weak self] countryName in
                OperationQueue.mainAsyncIfNeeded {
                    self?.searchViewController.isActive = false
                    let alert = self?.viewModel?.alertBuilder?.buildOkAlert(
                        with: Constants.setCountry,
                        message: countryName) {}
                    guard let alert = alert else { return }
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    private var searchViewController: UISearchController!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.theme.background
        tableView.register(SearchCountryCell.self, forCellReuseIdentifier: SearchCountryCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var notFoundLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.secondaryText
        label.backgroundColor = UIColor.theme.background
        label.text = Constants.countryNotFound
        label.textAlignment = .center
        label.font = UIFont.theme.searchCountry.notFoundLabel
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.theme.background
        [.setupSearchBar, .setupTableView, .makeDataSouce,
         .getCountries].forEach(perform)
    }
    
    private func setupSearchBar() {
        searchViewController = UISearchController(searchResultsController: nil)
        searchViewController.searchBar.delegate = self
        searchViewController.searchBar.searchBarStyle = .minimal
        searchViewController.searchBar.showsBookmarkButton = true
        searchViewController.searchBar.setImage(UIImage(systemName: SystemImageName.sliderHorizontal), for: .bookmark, state: .normal)
        searchViewController.searchBar.setImage(UIImage(systemName: SystemImageName.sliderHorizontal),
                                                for: .bookmark, state: [.highlighted, .selected])
        searchViewController.searchResultsUpdater = self
        searchViewController.searchBar.placeholder = Constants.searchByCountryAndCode
        searchViewController.obscuresBackgroundDuringPresentation = false
        searchViewController.searchBar.isTranslucent = true
        searchViewController.searchBar.backgroundImage = UIImage()
        searchViewController.searchBar.subviews[0].backgroundColor = UIColor.theme.background
        searchViewController.searchBar.tintColor = UIColor.theme.orange
        tableView.tableHeaderView = searchViewController.searchBar
        tableView.tableHeaderView?.backgroundColor = UIColor.theme.background
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.backgroundColor = UIColor.theme.background
        tableView.subviews.first?.backgroundColor = UIColor.theme.background
        view.addSubview(tableView)
        tableView.dataSource = dataSource
        tableView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        OperationQueue.main.cancelAllOperations()
    }
}

// MARK: - UITableViewDataSource
extension SearchCountryViewController {
    private enum Section {
        case main
    }
    
    private func makeDataSouce() {
        dataSource = UserDataSource(tableView: tableView, cellProvider: { tableView, _, country in
            guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                            SearchCountryCell.reuseIdentifier) as? SearchCountryCell
            else { return UITableViewCell() }
            cell.configure(country: country)
            return cell
        })
    }
    
    private func updateDataSource(_ data: [Country]) {
        var snapshot = CountrySnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate
extension SearchCountryViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let country = dataSource?.itemIdentifier(for: indexPath) else { return }
        perform(.selectCountry(country))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        perform(.willDisplayCells(indexPath: indexPath,
                                  isActiveSearch: searchViewController.isActive))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard filteredCountries.isNotEmpty else { return tableView.frame.size.height * 0.5 }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard filteredCountries.isNotEmpty else { return notFoundLabel }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - UISearchResultsUpdating
extension SearchCountryViewController {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchViewController.searchBar.text else { return }
        perform(.updateSearchResults(searchText: searchText))
    }
}

// MARK: - UISearchBarDelegate
extension SearchCountryViewController {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        Log.info("tapped filterBarButton")
    }
}

// MARK: - ALL ACTIONS
extension SearchCountryViewController {
    private enum SearchCountryAction {
        case getCountries
        case setupSearchBar
        case setupTableView
        case makeDataSouce
        case updateDataSource(_ data: [Country])
        case updateSearchResults(searchText: String)
        case willDisplayCells(indexPath: IndexPath, isActiveSearch: Bool)
        case selectCountry(_ country: Country)
    }
    
    private func perform(_ action: SearchCountryAction) {
        switch action {
        case .getCountries: viewModel?.getCountries()
        case .setupSearchBar: setupSearchBar()
        case .setupTableView: setupTableView()
        case .makeDataSouce: makeDataSouce()
        case .updateDataSource(let countries): updateDataSource(countries)
        case .selectCountry(let country): viewModel?.selectCountry(country: country)
        case .updateSearchResults(let searchText):
            viewModel?.updateSearchResults(searchText: searchText,
                                           countries: countries,
                                           filteredCountries: filteredCountries)
        case .willDisplayCells(indexPath: let indexPath,
                               isActiveSearch: let isActiveSearch):
            viewModel?.willDisplayCells(indexPath: indexPath,
                                        isActiveSearch: isActiveSearch,
                                        countries: countries,
                                        filteredCountries: filteredCountries)
        }
    }
}

// MARK: - UISearchTextField Custom Design
extension UISearchTextField {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        borderStyle = .none
        layer.cornerCurve = .continuous
        layer.cornerRadius = 4
        layer.backgroundColor = UIColor.systemGray6.cgColor
    }
}

// MARK: Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct SearchCountryViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let dependency = DependenciesMock()
        let viewController = UINavigationController(rootViewController: SearchCountryAssembly.configure(dependency))
        Group {
            PreviewViewController(viewController)
                .edgesIgnoringSafeArea(.all)
                .previewDisplayName("Light")
            PreviewViewController(viewController)
                .edgesIgnoringSafeArea(.all)
                .previewDisplayName("Dark")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
