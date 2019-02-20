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
		session.startNewClimb();
		session.completeClimbAsSuccess(rating);

		session.startNewClimb();
		session.completeClimbAsFailure(rating);

		// Assert
		logger.debug("Assert multiple completed climbs");
		Test.assertEqual(2, session.getNumberOfCompletedClimbs());

		logger.debug("Multiple saved completed climbs");
		var completedClimbs = session.getCompletedClimbs();
		Test.assert(completedClimbs[0].wasSuccessful());
		Test.assert(!completedClimbs[1].wasSuccessful());

		return true;
	}

	function assertNoActiveClimb(session) {
		Test.assert(null == session.getActiveClimb());
	}

	function createSession() {
		return new ClimbingSession(Time);
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
	}
}
