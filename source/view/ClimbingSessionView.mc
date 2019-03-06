using Toybox.Time;
using Toybox.Timer;
using Toybox.WatchUi;
using ClimbingCore as Core;

module ClimbingView
{
    class ClimbingSessionController extends WatchUi.BehaviorDelegate
    {
        private const UPDATE_RATE_MS = 1000;

        private var climbingSession;
        private var view;
        private var timer;

        function initialize() {
            BehaviorDelegate.initialize();
            climbingSession = new Core.ClimbingSession(Time.now());

            view = new ClimbingSessionView(getViewModel());

            timer = new Timer.Timer();
            startTimer();
        }

        function getView() {
            return self.view;
        }

        function onCancelClimb() {
            self.climbingSession.cancelActiveClimb();
            self.restoreSessionView();
        }

        function onCompletedClimb(climbEndTime, successfulClimb, rating) {
            if(successfulClimb) {
                self.climbingSession.completeClimbAsSuccess(climbEndTime, rating);
            } else {
                self.climbingSession.completeClimbAsFailure(climbEndTime, rating);
            }

            self.restoreSessionView();
        }

        function onCompleteSessionPromptResponse(shouldComplete) {
            if(!shouldComplete) {
                self.restoreSessionView();
                return;
            }

            var completedSessionController = new CompletedSessionController(
                self.climbingSession.complete(Time.now())
            );

            WatchUi.switchToView(
                completedSessionController.getView(),
                completedSessionController,
                WatchUi.SLIDE_UP
            );
        }

        function onNextPage() {
            self.startClimb();
            return true;
        }

        function onPreviousPage() {
            self.promptToCompleteSession();
            return true;
        }

        function onSelect() {
            self.startClimb();
            return true;
        }

        function onTimer() {
            self.view.update(self.getViewModel());
        }

        private function getViewModel() {
            return sessionToViewModel(self.climbingSession, Time.now());
        }

        private function promptToCompleteSession() {
            self.timer.stop();
            var prompt = WatchUi.loadResource(Rez.Strings.CompleteSessionPrompt);
            WatchUi.pushView(
                new WatchUi.Confirmation(prompt),
                new CompleteSessionConfirmationDelegate(self),
                WatchUi.SLIDE_DOWN
            );
        }

        private function restoreSessionView() {
            self.startTimer();
            self.view.update(self.getViewModel());
        }

        private function startClimb() {
            self.timer.stop();
            self.climbingSession.startNewClimb(Time.now());

            var climbController = new ClimbController(
                self,
                self.climbingSession.getActiveClimb(),
                self.climbingSession.getLastClimbType()
            );

            WatchUi.pushView(climbController.getView(), climbController, WatchUi.SLIDE_UP);
        }

        private function startTimer() {
            timer.start(method(:onTimer), UPDATE_RATE_MS, true);
        }
    }


    class ClimbingSessionView extends WatchUi.View
    {
        private var sessionViewModel;

        function initialize(viewModel) {
            View.initialize();
            sessionViewModel = viewModel;
        }

        // Load your resources here
        function onLayout(dc) {
            setLayout(Rez.Layouts.SessionLayout(dc));
        }

        // Called when this View is brought to the foreground. Restore
        // the state of this View and prepare it to be shown. This includes
        // loading resources into memory.
        function onShow() {
        }

        // Update the view
        function onUpdate(dc) {
            View.findDrawableById("total_time_text")
                .setText(sessionViewModel.getDuration());

            View.findDrawableById("rest_time_text")
                .setText(sessionViewModel.getRestTime());

            View.findDrawableById("climbs_attempted_text")
                .setText(sessionViewModel.getTotalClimbs());

            View.findDrawableById("climbs_successful_text")
                .setText(sessionViewModel.getSuccessfulClimbs());

            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
        }

        // Called when this View is removed from the screen. Save the
        // state of this View here. This includes freeing resources from
        // memory.
        function onHide() {
        }

        function update(newModel) {
            self.sessionViewModel = newModel;
            WatchUi.requestUpdate();
        }
    }

    class CompleteSessionConfirmationDelegate extends WatchUi.ConfirmationDelegate
    {
        private var parentController;

        function initialize(parent) {
            ConfirmationDelegate.initialize();
            parentController = parent;
        }

        function onResponse(response) {
            var shouldComplete = (response == WatchUi.CONFIRM_YES);
            self.parentController.onCompleteSessionPromptResponse(shouldComplete);
        }
    }
}
