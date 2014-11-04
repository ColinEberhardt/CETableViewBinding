##ReactiveCocoa TableView Binding Helper

This project contains a simple helper class that can be used to bind array properties on ReactiveCocoa view models to table views. Here's a quick example of how to use it:

    // create a cell template
    UINib *nib = [UINib nibWithNibName:@"CETweetTableViewCell" bundle:nil];
    
    // bind the ViewModels 'searchResults' property to a table view
    [CETableViewBindingHelper
         bindingHelperForTableView:self.searchResultsTable
                      sourceSignal:RACObserve(self.viewModel, searchResults)
                  selectionCommand:nil
                      templateCell:nib];
                              
In the above example, the nib `CETweetTableViewCell` defines a `UITableViewCell` subclass which is used for rendering the items within the array. This cell must implement the `CEReactiveView` protocol.

The binding helper binds a source signal, which is a signal constructed from the array property of the view model, to a `UITableView`. As a result, the table view will render the contents of the array using the given cell template. Updates to the array property on the view model are automatically be propagated.

If you need to handle selection, you can supply a `RACCommand` to the binding helper via the `selectionCommand` argument. This command is executed each time selection changes.

If you need to mutate (i.e. add / remove items) the array property of the view model, use the `CEObservableMutableArray` class. This is an `NSMutableArray` subclass that informs observers of mutations, allowing the binding helper to add / remove rows from the table view automatically. See the `QuotesListExample` project for an example of binding to mutable arrays.

This project contains two example projects:

+ `TwitterSearchExample` - An example app that searches twitter, with a table view, bound using the helper, displaying the results.
+ `QuotesListExample` - An example app that shows a list of stock quotes, where prices are dynamically updated and items are added / removed.

To learn more about this helper, see the following blog posts:

 + [Binding to a UITableView from a ReactiveCocoa ViewModel](http://www.scottlogic.com/blog/2014/05/11/reactivecocoa-tableview-binding.html)
 + [Binding mutable arrays with ReactiveCocoa](http://www.scottlogic.com/blog/2014/11/04/mutable-array-binding-reactivecocoa.html) 