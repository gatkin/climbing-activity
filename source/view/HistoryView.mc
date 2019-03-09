using Toybox.WatchUi;


module ClimbingView
{
    class HistoryController extends WatchUi.Menu2InputDelegate
    {
        private var view;

        // Create a new history view controller.
        // viewModel: A HistoryViewModel object
        function initialize(viewModel) {
            Menu2InputDelegate.initialize();
            view = createMenu(viewModel);   
        }

        function getView() {
            return self.view;
        }

        function onSelect(itemId) {
        }

        private function createMenu(viewModel) {
            var menu = new WatchUi.Menu2({:title => viewModel.getTitle()});

            var items = viewModel.getMenuItems();
            for(var i = 0; i < items.size(); i++) {
                menu.addItem(items[i]);
            }

            return menu;
        }
    }
}