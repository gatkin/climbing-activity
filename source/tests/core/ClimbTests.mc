using Toybox.Test;
using Toybox.Time;

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
	
	// Act
	logger.debug("end climb");
	var completedClimb = climb.completeAsSuccess(endTime);
	
	// Assert
	logger.debug("climb was successful");
	Test.assert(completedClimb.wasSuccessful());
	
	logger.debug("correct duration...can only compare by string for some reason");
	var actualDuration = completedClimb.getDuration().value();
	var expectedDuration = duration.value();
	Test.assertEqual(expectedDuration.toString(), actualDuration.toString());
	
	return true;
}

function createActiveClimb(startTime) {
	return new ActiveClimb(startTime);
}