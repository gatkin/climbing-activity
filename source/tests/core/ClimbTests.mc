using Toybox.Test;
using Toybox.Time;


module ClimbingCore
{
	(:test)
	function createActiveClimbInitializesClimb(logger) {
		// Arrange
		var startTime = Time.now();
		
		// Act
		logger.debug("create climb");
		var climb = new ActiveClimb(startTime);
		
		// Assert
		logger.debug("start time is set");
		Test.assertEqual(startTime, climb.getStartTime());
		
		logger.debug("id is set");
		Test.assertEqual(startTime.value(), climb.getId());
		
		return true;
	}


	(:test)
	function completeAsSuccessCreatesACompletedClimb(logger) {
		// Arrange
		var startTime = Time.now();
		var duration = new Time.Duration(60);
		var endTime = startTime.add(duration);
		
		var climb = createActiveClimb(startTime);
		var rating = new BoulderRating(2);
		
		// Act
		logger.debug("end climb");
		var completedClimb = climb.completeAsSuccess(endTime, rating);
		
		// Assert
		logger.debug("climb was successful");
		Test.assert(completedClimb.wasSuccessful());
		
		logger.debug("correct duration");
		assertDurationsAreEqual(duration, completedClimb.getDuration());

		logger.debug("correct rating");
		Test.assertEqual(rating, completedClimb.getRating());

		logger.debug("correct id");
		Test.assertEqual(climb.getId(), completedClimb.getId());
		
		return true;
	}

	(:test)
	function completeAsFailureCreatesACompletedClimb(logger) {
		// Arrange
		var startTime = Time.now();
		var duration = new Time.Duration(60);
		var endTime = startTime.add(duration);
		
		var climb = createActiveClimb(startTime);
		var rating = new RopedClimbRating(1);
		
		// Act
		logger.debug("end climb");
		var completedClimb = climb.completeAsFailure(endTime, rating);
		
		// Assert
		logger.debug("climb was not successful");
		Test.assertEqual(false, completedClimb.wasSuccessful());
		
		logger.debug("correct duration");
		assertDurationsAreEqual(duration, completedClimb.getDuration());

		logger.debug("correct rating");
		Test.assertEqual(rating, completedClimb.getRating());

		logger.debug("correct id");
		Test.assertEqual(climb.getId(), completedClimb.getId());
		
		return true;
	}

	function assertDurationsAreEqual(expected, actual) {
		// It only works to compare durations by string
		var expectedDuration = expected.value().toString();
		var actualDuration = actual.value().toString();
		Test.assertEqual(expectedDuration, actualDuration);
	}

	function createActiveClimb(startTime) {
		return new ActiveClimb(startTime);
	}
}