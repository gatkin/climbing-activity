using Toybox.Test;
using Toybox.Time;


module ClimbingCore
{
	(:test)
	function createClimbingSessionInitializesSession(logger) {
		// Arrange
		var startTime = Time.now();
		var timeProvider = new MockTimeProvider(startTime);
		
		// Act
		logger.debug("create new session");
		var session = new ClimbingSession(timeProvider);
		
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
	function startNewClimbCreatesAnActiveClimb(logger) {
		// Arrange
		var session = createSession();

		// Act
		logger.debug("start new climb");
		session.startNewClimb();

		// Assert
		logger.debug("assert active climb is not null");
		Test.assert(session.getActiveClimb());

		return true;
	}

	(:test)
	function completeActiveClimbAsSuccessCreatesACompletedClimb(logger) {
		// Arrange
		var session = createSessionWithActiveClimb();

		// Act
		logger.debug("Complete climb as a success");
		session.completeClimbAsSuccess(new BoulderRating(0));

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
	function completeActiveClimbAsFailureCreatesACompletedClimb(logger) {
		// Arrange
		var session = createSessionWithActiveClimb();

		// Act
		logger.debug("Complete climb as a failure");
		session.completeClimbAsFailure(new BoulderRating(0));

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
	function completeActiveClimbSavesMultipleClimbs(logger) {
		// Arrange
		var session = createSession();
		var rating = new BoulderRating(0);

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
	function getElapsedDurationReturnsTotalTimeSinceStart(logger) {
		// Arrange
		var startTime = Time.now();
		var timeProvider = new MockTimeProvider(startTime);
		var session = new ClimbingSession(timeProvider);

		var duration = new Time.Duration(60);
		var currentTime = startTime.add(duration);
		timeProvider.setCurrentTime(currentTime);

		// Act
		logger.debug("get elapsed duration");
		var actualElapsedDuration = session.getElapsedDuration();

		// Assert
		logger.debug("assert durations are equal");
		assertDurationsAreEqual(duration, actualElapsedDuration);

		return true;
	}

	(:test)
	function getNumberOfSuccessfulClimbsReturnsCorrectCount(logger) {
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

	
}
