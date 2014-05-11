##ReactiveCocoa TableView Binding Helper

This project demonstrates a simple helper class that can be used to bind `NSArray` properties on ReactiveCocoa ViewModels to a `UITableView`. Here's a quick example of how to use it:

    // create a cell template
    UINib *nib = [UINib nibWithNibName:@"CETweetTableViewCell" bundle:nil];
    
    // bind the ViewModels 'searchResults' property to a table view
    [CETableViewBindingHelper bindingHelperForTableView:self.searchResultsTable
                              sourceSignal:RACObserve(self.viewModel, searchResults)
                              templateCell:nib];
                              
For further details see this blog post:                              