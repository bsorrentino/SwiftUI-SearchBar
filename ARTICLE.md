# How to use native searchbar in SwiftUI for iOS, macOS, tvOS

In my Developer journey using Swiftui often I've dealt with adding search bar on top of list, grid, etc…

In these cases I've always ask to myself a question: have I to use native widget or I’ve to implement a completely new widget from scratch using SwiftUi ?
But since I'm a (very)  lazy developer I decided to reuse the native widget thinking that it would have been easier solution, unfortunately It would haven’t been so.

For this reason I've decided to write this article for sharing my experience hoping that this could help other lazy developers like me. 

My solution design will consist in implementing a searchbar as swiftui container (ie. using a @viewbuilder) so we'll define the search bar and also the view where the search result will be applied


So let's start, beginning With iOS where the native widget is UIsearchbox we have to implement a uiviewrepresentable



