using Toybox.Application;
using Toybox.System;
using Toybox.WatchUi;
using ClimbingView as View;


class ClimbingActivityApp extends Application.AppBase
{
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new View.MainView(), new View.MainViewDelegate() ];
    }
}
