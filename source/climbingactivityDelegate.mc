using Toybox.WatchUi;

class ClimbingActivityDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new ClimbingActivityMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}