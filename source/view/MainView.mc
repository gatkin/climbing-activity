using Toybox.WatchUi;
using ClimbingCore.Storage as Storage;

module ClimbingView
{
    // Menus cannot be the initial view in a ConnectIQ app. Therefore, we create
    // an initial view to let the user transition to a menu.
    class MainView extends WatchUi.View
    {
        function initialize() {
            View.initialize();
        }

        function onLayout(dc) {
            setLayout(Rez.Layouts.Main(dc));
        }

        function onUpdate(dc) {
            View.onUpdate(dc);
        }
    }

    class MainViewDelegate extends WatchUi.BehaviorDelegate
    {
        function initialize() {
            BehaviorDelegate.initialize();
        }

        function onKey(keyEvent) {
            var key = keyEvent.getKey();
            if(key == WatchUi.KEY_ESC) {
                onEscape();
            } else {
                onContinue();
            }

            return true;
        }

        function onSwipe(swipeEvent) {
            var direction = swipeEvent.getDirection();
            if(direction == WatchUi.SWIPE_LEFT) {
                onEscape();
            } else {
                onContinue();
            }

            return true;
        }

        private function onContinue() {
            WatchUi.switchToView(
                new Rez.Menus.Main(),
                new MainMenuDelegate(),
                WatchUi.SLIDE_UP
            );
        }

        private function onEscape() {
            // Let the user exit the app.
            WatchUi.popView(WatchUi.SLIDE_LEFT);
        }
    }

    class MainMenuDelegate extends WatchUi.MenuInputDelegate
    {
        function initialize() {
            MenuInputDelegate.initialize();
        }

        function onMenuItem(selectedItem) {
            if(selectedItem == :ViewHistory) {
                openHistoryView();
            } else {
                openActiveSessionView();
            }
        }

        private function openActiveSessionView() {
            vibrateWatch();
            var controller = new ClimbingSessionController();
            WatchUi.pushView(
                controller.getView(),
                controller,
                WatchUi.SLIDE_UP
            );
        }

        private function openHistoryView() {
            var sessionAccessor = Storage.getSessionAccessor();
            var sessions = sessionAccessor.getSessions();
            var controller = new HistoryController(sessions);

            WatchUi.pushView(
                controller.getView(),
                controller,
                WatchUi.SLIDE_UP
            );
        }
    }
}