using Toybox.System;
using Toybox.Time;
using Toybox.Timer;
using Toybox.WatchUi;
using ClimbingCore as Core;

module ClimbingView
{
    class ClimbController extends WatchUi.BehaviorDelegate
    {
        private const UPDATE_RATE_MS = 1000;

        private var parentController;
        private var climb;
        private var lastClimbType;
        private var view;
        private var timer;
        private var climbEndTime;

        function initialize(controllerParent, activeClimb, typeOfLastClimb) {
            BehaviorDelegate.initialize();

            parentController = controllerParent;
            climb = activeClimb;
            lastClimbType = typeOfLastClimb;
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
                new SuccessfulClimbConfirmationDelegate(self, self.lastClimbType),
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
            var durationText = formatDuration(self.duration);
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
        private var lastClimbType;

        function initialize(parent, typeOfLastClimb) {
            ConfirmationDelegate.initialize();
            parentController = parent;
            lastClimbType = typeOfLastClimb;
        }

        function onResponse(response) {
            var successfulClimb = (response == WatchUi.CONFIRM_YES);

            // Open the rating menu to whatever the user used last time.
            if(self.lastClimbType == Core.CLIMB_TYPE_BOULDERING) {
                openBoulderRatingMenu(self.parentController, successfulClimb);
            } else {
                openRopedClimbRatingMenu(self.parentController, successfulClimb);
            }
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
            if(selectedItem == :RopedClimb) {
                // Allow the user to provide a rating for a roped climb rather than a bouldering climb
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
                openRopedClimbRatingMenu(self.parentController, self.successfulClimb);
                return;
            }

            var rating = new Core.BoulderRating(selectedItem);
            self.parentController.onClimbRatingProvided(self.successfulClimb, rating);
        }
    }


    class RopedClimbRatingMenuDelegate extends WatchUi.MenuInputDelegate
    {
        private var parentController;
        private var successfulClimb;

        function initialize(parent, climbSuccessful) {
            MenuInputDelegate.initialize();
            parentController = parent;
            successfulClimb = climbSuccessful;
        }

        function onMenuItem(selectedItem) {
            if(selectedItem == :Boulder) {
                // Allow the user to provide a rating for a roped climb rather than a bouldering climb
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
                openBoulderRatingMenu(self.parentController, self.successfulClimb);
                return;
            }

            var rating = new Core.RopedClimbRating(selectedItem);
            self.parentController.onClimbRatingProvided(self.successfulClimb, rating);
        }
    }

    function openBoulderRatingMenu(parentController, successfulClimb) {
        WatchUi.pushView(
            new Rez.Menus.BoulderRating(),
            new BoulderRatingMenuDelegate(parentController, successfulClimb),
            WatchUi.SLIDE_UP
        );
    }

    function openRopedClimbRatingMenu(parentController, successfulClimb) {
        WatchUi.pushView(
            new Rez.Menus.RopedClimbRating(),
            new RopedClimbRatingMenuDelegate(parentController, successfulClimb),
            WatchUi.SLIDE_UP
        );
    }
}
