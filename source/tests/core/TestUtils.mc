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
        return createCompletedSessionWithId(1);
    }

    function createCompletedSessionWithId(id) {
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

    function createCompletedSessionWithStartTimeAndClimbCount(
        startTime,
        climbCount
    )
    {
        var duration = new Time.Duration(90);
        var endTime = startTime.add(duration);
        
        var climbs = new [climbCount];
        for(var i = 0; i < climbCount; i++) {
            climbs[i] = createSuccessfulClimb();
        }

        var session = new CompletedClimbingSession(
            startTime.value(),
            startTime,
            endTime,
            climbs
        );

        return session;
    }

    function createFailedClimb() {
        return createClimb(false);
    }

    function createMultipleCompletedSessions() {
        var idA = 1;
        var startTimeA = new Time.Moment(1551568192);
        var durationA = new Time.Duration(95);
        var endTimeA = startTimeA.add(durationA);
        var climbsA = [
            createSuccessfulClimb(),
            createFailedClimb(),
            createSuccessfulClimb()
        ];

        var sessionA = new CompletedClimbingSession(
            idA,
            startTimeA,
            endTimeA,
            climbsA
        );

        var idB = 2;
        var startTimeB = new Time.Moment(1551923105);
        var durationB = new Time.Duration(235);
        var endTimeB = startTimeB.add(durationB);
        var climbsB = [
            createFailedClimb(),
            createSuccessfulClimb(),
            createSuccessfulClimb(),
            createSuccessfulClimb(),
        ];

        var sessionB = new CompletedClimbingSession(
            idB,
            startTimeB,
            endTimeB,
            climbsB
        );

        return [sessionA, sessionB];
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
