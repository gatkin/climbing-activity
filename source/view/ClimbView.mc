using Toybox.System;
using Toybox.Time;
using Toybox.Timer;
using Toybox.WatchUi;
using ClimbingCore as Core;
using ClimbingView;


class ClimbController extends WatchUi.BehaviorDelegate
{
    private const UPDATE_RATE_MS = 1000;

    private var parentController;
    private var view;
    private var climb;
    private var timer;

    function initialize(controllerParent, activeClimb) {
        BehaviorDelegate.initialize();
        parentController = controllerParent;
        climb = activeClimb;
        view = new ClimbView(getClimbDuration());

        timer = new Timer.Timer();
        timer.start(method(:onTimer), UPDATE_RATE_MS, true);
    }

    function getView() {
        return self.view;
    }

    function onBack() {
        self.timer.stop();
        self.timer = null;
        self.parentController.onChildBack();
        self.parentController = null;
        return true;
    }

    function onTimer() {
        self.view.update(self.getClimbDuration());
    }

    private function getClimbDuration() {
        return Time.now().subtract(climb.getStartTime());
    }
}


class ClimbView extends WatchUi.View
{
    private var duration;

    function initialize(climbDuration) {
        View.initialize();
        duration = climbDuration;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.ClimbLayout(dc));
    }

    function onShow() {
    }

    function onUpdate(dc) {
        var durationText = ClimbingView.formatDuration(self.duration);
        View.findDrawableById("climb_time_text").setText(durationText);

        View.onUpdate(dc);
    }

    function onHide() {
    }

    function update(newDuration) {
        self.duration = newDuration;
        WatchUi.requestUpdate();
    }
}
