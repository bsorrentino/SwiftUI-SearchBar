//
//  SearchBar.swift
//  slides
//
//  Created by softphone on 01/07/21.
//
// @ref https://axelhodler.medium.com/creating-a-search-bar-for-swiftui-e216fe8c8c7f
// @ref https://github.com/ageres7-dev/WeatherTV/blob/1b20637c90ffa18b154fb526233f656f6845bc5d/WeatherTV/Views/SearchView/SearchWrapper.swift
// @ref http://blog.eppz.eu/swiftui-search-bar-in-the-navigation-bar/
import SwiftUI

class SearchBarViewController<Content:View> : UIViewController {
    
    let searchController: UISearchController
    fileprivate let contentViewController: UIHostingController<Content>

    init( searchController:UISearchController, content:Content ) {
     
        self.contentViewController = UIHostingController( rootView: content )
        self.searchController = searchController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update( content:Content?  ) {
        contentViewController.view.removeFromSuperview()
        if let content = content {
            contentViewController.rootView = content
        }
        view.addSubview(contentViewController.view)
        contentViewController.view.frame = view.bounds

        print( "view.bounds\n\(view.bounds)")
    }
    
    override func viewDidLoad() {
        log.trace( "viewDidLoad")
        
        super.viewDidLoad()

        update( content: nil )
        
//  WE GOT PROBLEM WITH REFRESH
//        addChild(contentViewController)
//        contentViewController.didMove(toParent: self)
    }
    
    
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        guard let parent = parent, parent.navigationItem.searchController == nil else  {return}

        log.trace( "didMove to \(parent)")
        parent.navigationItem.searchController = searchController

    }
}

struct SearchBar<Content: View>: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = SearchBarViewController<Content>
    
    @Binding var text: String
    
    var placeholder: String = ""
    @ViewBuilder var content: () -> Content

    class Coordinator: NSObject, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {

        @Binding var text: String

        
        init(text: Binding<String>) {
            _text = text
        }

        // MARK: - UISearchResultsUpdating impl
        
        // Called when user selects one of the search suggestion buttons displayed under the keyboard on tvOS.
        func updateSearchResults(for searchController: UISearchController) {

            // IMPORTANT!!!
            // only if text has changed it will be reassigned.
            // reassignment implies a content view update
            if( self.text != searchController.searchBar.text ) {
                self.text = searchController.searchBar.text ?? ""
            }
        }
        
        // Called when user selects one of the search suggestion buttons displayed under the keyboard on tvOS.
        // func updateSearchResults(for searchController: UISearchController, selecting searchSuggestion: UISearchSuggestion)

        // MARK: - UISearchBarDelegate impl

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<SearchBar>) -> UIViewControllerType {
        
        let searchController =  UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = context.coordinator
        searchController.searchBar.delegate = context.coordinator
        //searchController.delegate = context.coordinator

        searchController.searchBar.placeholder = placeholder
        searchController.obscuresBackgroundDuringPresentation = false

        return SearchBarViewController( searchController:searchController, content:content() )
        
        
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<SearchBar>) {
    
//        let contentViewController = uiViewController.contentViewController
//        contentViewController.view.removeFromSuperview()
//        contentViewController.rootView = content()
//        uiViewController.view.addSubview(contentViewController.view)
//        contentViewController.view.frame = uiViewController.view.bounds

        uiViewController.update( content: content() )

    }

}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("")) {
            EmptyView()
        }
    }
}
