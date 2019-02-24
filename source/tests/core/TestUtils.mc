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

    function completeBoulderClimb(session) {
        session.startNewClimb(Time.now());
        session.completeClimbAsSuccess(Time.now(), new BoulderRating(:V0));
    }

    function completeClimbWithStartAndEndTimes(session, climbStartTime, climbEndTime) {
        session.startNewClimb(climbStartTime);
        session.completeClimbAsFailure(climbEndTime, new BoulderRating(:V0));
    }

    function completeFailedClimb(session) {
        session.startNewClimb(Time.now());
        session.completeClimbAsFailure(Time.now(), new BoulderRating(:V0));
    }

    function completeRopedClimb(session) {
        session.startNewClimb(Time.now());
        session.completeClimbAsSuccess(Time.now(), new RopedClimbRating(:Y57));
    }

    function completeSuccessfulClimb(session) {
        session.startNewClimb(Time.now());
        session.completeClimbAsSuccess(Time.now(), new BoulderRating(:V0));
    }

    function createSession() {
        return createSessionWithStartTime(Time.now());
    }

    function createSessionWithStartTime(startTime) {
        return new ClimbingSession(startTime);
    }

    function createSessionWithActiveClimb() {
        var session = createSession();
        session.startNewClimb(Time.now());
        return session;
    }
}
