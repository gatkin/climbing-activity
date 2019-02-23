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
    private var climbEndTime;

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
        self.cancelClimb();
        return true;
    }

    function onClimbRatingProvided(successfulClimb, rating) {
        self.parentController.onCompletedClimb(
            self.climbEndTime,
            successfulClimb,
            rating
        );
        self.parentController = null;
    }

    function onNextPage() {
        self.completeClimb();
        return true;
    }

    function onPreviousPage() {
        self.cancelClimb();
        return true;
    }

    function onSelect() {
        self.completeClimb();
        return true;
    }

    function onTimer() {
        self.view.update(self.getClimbDuration());
    }

    private function cancelClimb() {
        self.stopTimer();
        self.parentController.onCancelClimb();
        self.parentController = null;
    }

    private function completeClimb() {
        self.stopTimer();
        self.climbEndTime = Time.now();

        var prompt = WatchUi.loadResource(Rez.Strings.successful_climb_prompt);
        WatchUi.pushView(
            new WatchUi.Confirmation(prompt),
            new SuccessfulClimbConfirmationDelegate(self),
            WatchUi.SLIDE_UP
        );
    }

    private function getClimbDuration() {
        return Time.now().subtract(climb.getStartTime());
    }

    private function stopTimer() {
        self.timer.stop();
        self.timer = null;
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


class SuccessfulClimbConfirmationDelegate extends WatchUi.ConfirmationDelegate
{
    private var parentController;

    function initialize(parent) {
        ConfirmationDelegate.initialize();
        parentController = parent;
    }

    function onResponse(response) {
        var successfulClimb = (response == WatchUi.CONFIRM_YES);
        WatchUi.pushView(
            new Rez.Menus.BoulderRating(),
            new BoulderRatingMenuDelegate(self.parentController, successfulClimb),
            WatchUi.SLIDE_UP
        );
    }
}


class BoulderRatingMenuDelegate extends WatchUi.MenuInputDelegate
{
    private var parentController;
    private var successfulClimb;

    function initialize(parent, climbSuccessful) {
        MenuInputDelegate.initialize();
        parentController = parent;
        successfulClimb = climbSuccessful;
    }

    function onMenuItem(selectedItem) {
        var rating = new Core.BoulderRating(selectedItem);
        parentController.onClimbRatingProvided(self.successfulClimb, rating);
    }
}
