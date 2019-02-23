using Toybox.System;
using Toybox.Time;
using Toybox.Timer;
using Toybox.WatchUi;
using ClimbingCore as Core;
using ClimbingView;


class ClimbController extends WatchUi.BehaviorDelegate
{
    private var view;

    function initialize() {
        BehaviorDelegate.initialize();
        view = new ClimbView();
    }

    function getView() {
        return self.view;
    }
}


class ClimbView extends WatchUi.View
{
    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.ClimbLayout(dc));
    }

    function onShow() {
    }

    function onUpdate(dc) {
        View.onUpdate(dc);
    }

    function onHide() {
    }
}
