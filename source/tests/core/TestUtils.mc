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
        session.completeClimbAsSuccess(Time.now(), createBoulderRating());
    }

    function completeClimbWithStartAndEndTimes(session, climbStartTime, climbEndTime) {
        session.startNewClimb(climbStartTime);
        session.completeClimbAsFailure(climbEndTime, createBoulderRating());
    }

    function completeFailedClimb(session) {
        session.startNewClimb(Time.now());
        session.completeClimbAsFailure(Time.now(), createBoulderRating());
    }

    function completeRopedClimb(session) {
        session.startNewClimb(Time.now());
        session.completeClimbAsSuccess(Time.now(), createRopedClimbRating());
    }

    function completeSuccessfulClimb(session) {
        session.startNewClimb(Time.now());
        session.completeClimbAsSuccess(Time.now(), createBoulderRating());
    }

    function createBoulderRating() {
        return new BoulderRating(:V0);
    }

    function createClimb(success) {
        return new CompletedClimb(
            1,
            Time.now(),
            Time.now(),
            new BoulderRating(:V0),
            success
        );
    }

    function createCompletedSession() {
        var id = 1;
        var startTime = new Time.Moment(1551568192);
        var duration = new Time.Duration(95);
        var endTime = startTime.add(duration);
        var climbs = [
            createSuccessfulClimb(),
            createFailedClimb(),
            createSuccessfulClimb()
        ];

        var session = new CompletedClimbingSession(
            id,
            startTime,
            endTime,
            climbs
        );

        return session;
    }

    function createFailedClimb() {
        return createClimb(false);
    }

    function createRopedClimbRating() {
        return new RopedClimbRating(:Y57);
    }

    function createSuccessfulClimb() {
        return createClimb(true);
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
