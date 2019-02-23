using Toybox.Application;
using Toybox.System;
using Toybox.WatchUi;

class ClimbingActivityApp extends Application.AppBase
{
    private var sessionController;

    function initialize() {
        AppBase.initialize();
        sessionController = new ClimbingSessionController();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ sessionController.getView(), sessionController ];
    }
}
