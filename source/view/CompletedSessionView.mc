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
            view = new CompletedSessionView();
        }

        function getView() {
            return self.view;
        }
    }

    class CompletedSessionView extends WatchUi.View
    {
        function initialize() {
            View.initialize();
        }

        function onLayout(dc) {
            setLayout(Rez.Layouts.CompletedSessionLayout(dc));
        }

        function onShow() {
        }

        function onUpdate(dc) {
            View.onUpdate(dc);
        }

        function onHide() {
        }
    }
}