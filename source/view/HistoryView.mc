using Toybox.WatchUi;


module ClimbingView
{
    class HistoryController extends WatchUi.Menu2InputDelegate
    {
        private var view;
        private var sessions;

        // Create a new history view controller.
        // completedSessions: List of CompletedSession objects ordered from oldest to most recent.
        function initialize(completedSessions) {
            Menu2InputDelegate.initialize();
            sessions = completedSessions;
            view = createMenu(sessionHistoryToViewModel(sessions));   
        }

        function getView() {
            return self.view;
        }

        function onSelect(selectedItem) {
            var sessionId = selectedItem.getId();

            var selectedSession = null;
            for(var i = 0; i < self.sessions.size(); i++) {
                var session = self.sessions[i];
                if(session.getId() == sessionId) {
                    selectedSession = session;
                    break;
                }
            }

            // Open the details for the selected session.
            if(null != selectedSession) {
                var controller = new CompletedSessionController(selectedSession);

                WatchUi.pushView(
                    controller.getView(),
                    controller,
                    WatchUi.SLIDE_LEFT
                );
            }
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