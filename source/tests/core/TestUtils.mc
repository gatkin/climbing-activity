using Toybox.Test;
using Toybox.Time;


module ClimbingCore
{
    function assertDurationsAreEqual(expected, actual) {
        // It only works to compare durations by string
        var expectedDuration = expected.value().toString();
        var actualDuration = actual.value().toString();
        Test.assertEqual(expectedDuration, actualDuration);
    }
    
    function assertNoActiveClimb(session) {
        Test.assert(null == session.getActiveClimb());
    }

    function completeFailedClimb(session) {
        session.startNewClimb();
        session.completeClimbAsFailure(new BoulderRating(2));
    }

    function completeSuccessfulClimb(session) {
        session.startNewClimb();
        session.completeClimbAsSuccess(new BoulderRating(2));
    }

    function createSession() {
        return new ClimbingSession(Time);
    }

    function createSessionWithTimeProvider(provider) {
        return new ClimbingSession(provider);
    }

    function createSessionWithActiveClimb() {
        var session = createSession();
        session.startNewClimb();
        return session;
    }

    class MockTimeProvider
    {
        private var time;

        function initialize(t) {
            time = t;
        }

        function now() {
            return self.time;
        }

        function setCurrentTime(t) {
            self.time = t;
        }
    }
}
