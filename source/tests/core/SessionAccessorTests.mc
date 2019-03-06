using Toybox.Application.Storage;
using Toybox.Test;
using ClimbingCore as Core;


module ClimbingCore
{
module Storage
{
    (:test)
    function ratingToDict_ConvertsBoulderRating(logger) {
        // Arrange
        var rating = Core.createBoulderRating();

        // Act
        logger.debug("convert to dict");
        var ratingDict = ratingToDict(rating);

        logger.debug("convert from dict");
        var actualRating = ratingFromDict(ratingDict);

        // Assert
        logger.debug("ratings are equal");
        Test.assertEqual(rating, actualRating);

        return true;
    }

    (:test)
    function ratingToDict_ConvertsRopedClimbRating(logger) {
        // Arrange
        var rating = Core.createRopedClimbRating();

        // Act
        logger.debug("convert to dict");
        var ratingDict = ratingToDict(rating);

        logger.debug("convert from dict");
        var actualRating = ratingFromDict(ratingDict);

        // Assert
        logger.debug("ratings are equal");
        Test.assertEqual(rating, actualRating);

        return true;
    }

    (:test)
    function climbFromDict_ConvertsClimb(logger) {
        // Arrange
        var climb = Core.createSuccessfulClimb();

        // Act
        logger.debug("to dict");
        var climbDict = climbToDict(climb);
        logger.debug(climbDict.toString());

        logger.debug("from dict");
        var actualClimb = climbFromDict(climbDict);

        // Assert
        logger.debug("climbs are equal");
        Test.assertEqual(climb, actualClimb);

        return true;
    }

    (:test)
    function sessionFromDict_ConvertsSession(logger) {
        // Arrange
        var session = Core.createCompletedSession();

        // Act
        logger.debug("to dict");
        var sessionDict = sessionToDict(session);
        logger.debug(sessionDict.toString());

        logger.debug("from dict");
        var actualSession = sessionFromDict(sessionDict);

        // Assert
        logger.debug("sessions are equal");
        Test.assertEqual(session, actualSession);

        return true;
    }

    (:test)
    function saveCompletedSession_PersistsCompletedSession(logger) {
        // Arrange
        var accessor = createSessionAccessor();
        var session = Core.createCompletedSession();

        // Act
        logger.debug("save session");
        accessor.saveCompletedSession(session);

        // Assert
        logger.debug("data is persisted");
        var actualSessions = Storage.getValue(accessor.getStorageKey()); 
        Test.assertEqual(1, actualSessions.size());

        return true;
    }

    function createSessionAccessor() {
        return new SessionAccessor();
    }
}
}