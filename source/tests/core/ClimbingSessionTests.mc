using Toybox.Test;
using Toybox.Time;


(:test)
function createClimbingSessionInitializesSession(logger) {
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
	
	logger.debug("empty list of climbs");
	Test.assertEqual(0, session.getNumberOfClimbs());
	return true;
}
