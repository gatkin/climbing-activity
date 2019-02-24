using Toybox.Test;
using Toybox.Time;


module ClimbingCore
{
    (:test)
    function createClimbingSession_InitializesSession(logger) {
        // Arrange
        var startTime = Time.now();

        // Act
        logger.debug("create new session");
        var session = new ClimbingSession(startTime);

        // Assert
        logger.debug("start time is set");
        Test.assertEqual(startTime, session.getStartTime());

        logger.debug("id is set");
        Test.assertEqual(startTime.value(), session.getId());

        logger.debug("no active climb");
        assertNoActiveClimb(session);

        logger.debug("empty list of climbs");
        Test.assertEqual(0, session.getNumberOfCompletedClimbs());
        return true;
    }

    (:test)
    function startNewClimb_CreatesAnActiveClimb(logger) {
        // Arrange
        var session = createSession();
        var climbStartTime = Time.now();

        // Act
        logger.debug("start new climb");
        session.startNewClimb(climbStartTime);

        // Assert
        logger.debug("assert active climb is not null");
        Test.assert(session.getActiveClimb());

        return true;
    }

    (:test)
    function completeActiveClimbAsSuccess_CreatesACompletedClimb(logger) {
        // Arrange
        var session = createSessionWithActiveClimb();
        var climbEndTime = Time.now();
        var climbRating = new BoulderRating(:V0);

        // Act
        logger.debug("Complete climb as a success");
        session.completeClimbAsSuccess(climbEndTime, climbRating);

        // Assert
        logger.debug("assert no active climb");
        assertNoActiveClimb(session);

        logger.debug("assert climb is kept as completed");
        Test.assertEqual(1, session.getNumberOfCompletedClimbs());

        logger.debug("completed climb is in list as successful");
        var completedClimbs = session.getCompletedClimbs();
        Test.assert(completedClimbs[0].wasSuccessful());

        return true;
    }

    (:test)
    function completeActiveClimbAsFailure_CreatesACompletedClimb(logger) {
        // Arrange
        var session = createSessionWithActiveClimb();
        var climbEndTime = Time.now();
        var climbRating = new BoulderRating(:V0);

        // Act
        logger.debug("Complete climb as a failure");
        session.completeClimbAsFailure(climbEndTime, climbRating);

        // Assert
        logger.debug("assert no active climb");
        assertNoActiveClimb(session);

        logger.debug("assert climb is kept as completed");
        Test.assertEqual(1, session.getNumberOfCompletedClimbs());

        logger.debug("completed climb is in list as not successful");
        var completedClimbs = session.getCompletedClimbs();
        Test.assert(!completedClimbs[0].wasSuccessful());

        return true;
    }

    (:test)
    function completeActiveClimb_SavesMultipleClimbs(logger) {
        // Arrange
        var session = createSession();

        // Act
        completeSuccessfulClimb(session);
        completeFailedClimb(session);

        // Assert
        logger.debug("Assert multiple completed climbs");
        Test.assertEqual(2, session.getNumberOfCompletedClimbs());

        logger.debug("Multiple saved completed climbs");
        var completedClimbs = session.getCompletedClimbs();
        Test.assert(completedClimbs[0].wasSuccessful());
        Test.assert(!completedClimbs[1].wasSuccessful());

        return true;
    }

    (:test)
    function getNumberOfSuccessfulClimbs_CountsOnlySuccessfulClimbs(logger) {
        // Arrange
        var session = createSession();

        // Act
        completeSuccessfulClimb(session);
        completeFailedClimb(session);
        completeSuccessfulClimb(session);

        // Assert
        var expectedSuccessfulClimbs = 2;
        var actualSuccessfulClimbs = session.getNumberOfSuccessfulClimbs();
        logger.debug("assert " + expectedSuccessfulClimbs + " == " + actualSuccessfulClimbs);
        Test.assertEqual(expectedSuccessfulClimbs, actualSuccessfulClimbs);

        return true;
    }

    (:test)
    function cancelClimb_RemovesActiveClimbWithoutSavingIt(logger) {
        // Arrange
        var session = createSessionWithActiveClimb();

        // Act
        logger.debug("Cancel active climb");
        session.cancelActiveClimb();

        // Assert
        logger.debug("assert no active climb");
        assertNoActiveClimb(session);

        logger.debug("climb was not saved");
        Test.assertEqual(0, session.getNumberOfCompletedClimbs());

        return true;
    }

    (:test)
    function getCurrentRestTime_ReturnsTotalDurationIfNoCompletedClimbs(logger) {
        // Arrange
        var sessionStartTime = Time.now();
        var session = createSessionWithStartTime(sessionStartTime);

        // Act
        logger.debug("get current rest time");
        var expectedDuration = new Time.Duration(60);
        var currentTime = sessionStartTime.add(expectedDuration);
        var actualDuration = session.getCurrentRestTime(currentTime);

        // Assert
        logger.debug("assert durations are equal");
        assertDurationsAreEqual(expectedDuration, actualDuration);

        return true;
    }

    (:test)
    function getCurrentRestTime_ReturnsTimeSinceLastCompletedClimb(logger) {
        // Arrange
        var sessionStartTime = Time.now();
        var climbStartTime = sessionStartTime.add(new Time.Duration(10));
        var climbEndTime = climbStartTime.add(new Time.Duration(30));

        var session = createSessionWithStartTime(sessionStartTime);
        completeClimbWithStartAndEndTimes(session, climbStartTime, climbEndTime);

        // Act
        logger.debug("get current rest time");
        var expectedDuration = new Time.Duration(45);
        var currentTime = climbEndTime.add(expectedDuration);
        var actualDuration = session.getCurrentRestTime(currentTime);

        // Assert
        logger.debug("assert durations are equal");
        assertDurationsAreEqual(expectedDuration, actualDuration);

        return true;
    }

    (:test)
    function getCurrentRestTime_ReturnsZeroIfHaveActiveClimb(logger) {
        // Arrange
        var sessionStartTime = Time.now();
        var climbStartTime = sessionStartTime.add(new Time.Duration(10));
        var currentTime = climbStartTime.add(new Time.Duration(30));

        var session = createSessionWithStartTime(sessionStartTime);
        session.startNewClimb(climbStartTime);

        // Act
        logger.debug("get current rest time");
        var actualDuration = session.getCurrentRestTime(currentTime);

        // Assert
        logger.debug("assert durations are equal");
        var expectedDuration = new Time.Duration(0);
        assertDurationsAreEqual(expectedDuration, actualDuration);

        return true;
    }

    (:test)
    function getLastClimbType_ReturnsTypeOfLastCompletedClimb(logger) {
        // Arrange
        var session = createSession();

        // Act/Assert
        completeBoulderClimb(session);
        var expectedClimbType = CLIMB_TYPE_BOULDERING;
        var actualClimbType = session.getLastClimbType();
        logger.debug("climb type: " + expectedClimbType + " == " + actualClimbType);
        Test.assertEqual(expectedClimbType, actualClimbType);

        completeRopedClimb(session);
        expectedClimbType = CLIMB_TYPE_ROPED_CLIMB;
        actualClimbType = session.getLastClimbType();
        logger.debug("climb type: " + expectedClimbType + " == " + actualClimbType);
        Test.assertEqual(expectedClimbType, actualClimbType);

        return true;
    }

    (:test)
    function getLastClimbType_ReturnsDefaultWhenNoCompletedClimbs(logger) {
        // Arrange
        var session = createSession();

        // Act/Assert
        var expectedClimbType = DEFAULT_CLIMB_TYPE;
        var actualClimbType = session.getLastClimbType();
        logger.debug("climb type: " + expectedClimbType + " == " + actualClimbType);
        Test.assertEqual(expectedClimbType, actualClimbType);

        return true;
    }
}
