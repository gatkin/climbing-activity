using Toybox.WatchUi;

class climbingactivityDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new climbingactivityMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}