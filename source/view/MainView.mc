using Toybox.WatchUi;
using ClimbingView;


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
                // Let the user exit the app.
                WatchUi.popView(WatchUi.SLIDE_LEFT);
            } else {
                WatchUi.pushView(
                    new Rez.Menus.Main(),
                    new MainMenuDelegate(),
                    WatchUi.SLIDE_UP
                );
            }

            return true;
        }
    }

    class MainMenuDelegate extends WatchUi.MenuInputDelegate
    {
        function initialize() {
            MenuInputDelegate.initialize();
        }

        function onMenuItem(selectedItem) {
            // Remove the main view with the image from the view stack to save memory.
            WatchUi.popView(WatchUi.SLIDE_UP);

            var controller = new ClimbingSessionController();
            WatchUi.pushView(
                controller.getView(),
                controller,
                WatchUi.SLIDE_UP
            );
        }
    }
}