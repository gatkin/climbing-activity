using Toybox.Test;
using Toybox.Time;


module ClimbingCore
{
    (:test)
    function createActiveClimb_InitializesClimb(logger) {
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
    function completeAsSuccess_CreatesACompletedClimb(logger) {
        // Arrange
        var startTime = Time.now();
        var duration = new Time.Duration(60);
        var endTime = startTime.add(duration);
        
        var climb = createActiveClimb(startTime);
        var rating = new BoulderRating(:V2);
        
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
    function completeAsFailure_CreatesACompletedClimb(logger) {
        // Arrange
        var startTime = Time.now();
        var duration = new Time.Duration(60);
        var endTime = startTime.add(duration);
        
        var climb = createActiveClimb(startTime);
        var rating = new RopedClimbRating(:Y58);
        
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

    function createActiveClimb(startTime) {
        return new ActiveClimb(startTime);
    }
}