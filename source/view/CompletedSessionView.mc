using Toybox.System;
using Toybox.Time;
using Toybox.Timer;
using Toybox.WatchUi;

module ClimbingView
{
    class CompletedSessionController extends WatchUi.BehaviorDelegate
    {
        private var view;
        private var session;

        function initialize(completedSession) {
            BehaviorDelegate.initialize();
            session = completedSession;
            view = new CompletedSessionView(
                completedSessionToViewModel(session)
            );
        }

        function getView() {
            return self.view;
        }
    }

    class CompletedSessionView extends WatchUi.View
    {
        private var model;

        function initialize(sessionModel) {
            View.initialize();
            model = sessionModel;
        }

        function onLayout(dc) {
            setLayout(Rez.Layouts.CompletedSessionLayout(dc));
        }

        function onShow() {
        }

        function onUpdate(dc) {
            View.findDrawableById("session_title")
                .setText(self.model.getTitle());
            
            View.findDrawableById("session_duration")
                .setText(self.model.getDuration());
            
            View.findDrawableById("climbs_attempted")
                .setText(self.model.getAttemptedClimbCount());

            View.findDrawableById("climbs_completed")
                .setText(self.model.getSuccessfulClimbCount());

            View.findDrawableById("climbs_failed")
                .setText(self.model.getFailedClimbCount());

            View.onUpdate(dc);
        }

        function onHide() {
        }
    }
}