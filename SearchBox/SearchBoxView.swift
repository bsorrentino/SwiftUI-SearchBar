//
//  SearchBar.swift
//  slides
//
//  Created by softphone on 01/07/21.
//
// @ref https://axelhodler.medium.com/creating-a-search-bar-for-swiftui-e216fe8c8c7f
// @ref https://github.com/ageres7-dev/WeatherTV/blob/1b20637c90ffa18b154fb526233f656f6845bc5d/WeatherTV/Views/SearchView/SearchWrapper.swift

import SwiftUI

class SearchBoxViewController<Content:View> : UIViewController {
    
    let searchControllerProvider: (() -> UISearchController)
    let contentViewController: UIHostingController<Content>

    init( contentViewController:UIHostingController<Content>, searchControllerProvider:@escaping () -> UISearchController) {
     
        self.contentViewController = contentViewController
        self.searchControllerProvider = searchControllerProvider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update( content:Content ) {
        contentViewController.view.removeFromSuperview()
        contentViewController.rootView = content
        view.addSubview(contentViewController.view)
        contentViewController.view.frame = view.bounds
        
        print( "view.bounds\n\(view.bounds)")
    }
    
    override func viewDidLoad() {
        log.trace( "viewDidLoad")
        
        super.viewDidLoad()

        view.addSubview(contentViewController.view)
        contentViewController.view.frame = view.bounds
        
        addChild(contentViewController)
        contentViewController.didMove(toParent: self)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if let parent = parent {
            if parent.navigationItem.searchController != nil {
                return
            }
            log.trace( "didMove to \(parent)")
            parent.navigationItem.searchController = searchControllerProvider()

         }
    }
}

struct SearchBar<Content: View>: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = SearchBoxViewController<Content>
    
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
            log.trace( "updateSearchResults text = \(searchController.searchBar.text ?? "")")
            
            if isInPreviewMode {
                self.text = "test in preview"
                return
            }
            
            // IMPORTANT!!!
            // only if text has changed it will be reassigned.
            // reassignment implies a content view update
            if( self.text != searchController.searchBar.text ) {
                log.trace( "updateSearchResults set text")
                self.text = searchController.searchBar.text ?? ""
            }
        }
        
        // Called when user selects one of the search suggestion buttons displayed under the keyboard on tvOS.
//        optional func updateSearchResults(for searchController: UISearchController, selecting searchSuggestion: UISearchSuggestion)

        // MARK: - UISearchBarDelegate impl

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            //text = searchText
        }

        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            //text = ""
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            log.trace( "searchBarCancelButtonClicked")
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<SearchBar>) -> UIViewControllerType {
        
        return SearchBoxViewController(contentViewController: UIHostingController(rootView: content() )) {
            
            let searchController =  UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = context.coordinator
            searchController.searchBar.delegate = context.coordinator
            //searchController.delegate = context.coordinator

            searchController.searchBar.placeholder = placeholder
            searchController.obscuresBackgroundDuringPresentation = false

            return searchController

        }
        
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<SearchBar>) {
        log.trace( "updateUIViewController - searchText:\(text)" )
        
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
