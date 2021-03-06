using Toybox.Test;
using Toybox.Time;
using ClimbingCore as Core;

module ClimbingView
{
    (:test)
    function formatDurationFormatsCorrectly(logger) {
        var testCases = [
            {:duration => new Time.Duration(0), :expected => "00:00"},
            {:duration => new Time.Duration(1), :expected => "00:01"},
            {:duration => new Time.Duration(10), :expected => "00:10"},
            {:duration => new Time.Duration(21), :expected => "00:21"},
            {:duration => new Time.Duration(60), :expected => "01:00"},
            {:duration => new Time.Duration(61), :expected => "01:01"},
            {:duration => new Time.Duration(75), :expected => "01:15"},
            {:duration => new Time.Duration(615), :expected => "10:15"},
            {:duration => new Time.Duration(675), :expected => "11:15"},
            {:duration => new Time.Duration(3669), :expected => "1:01"},
        ];
        
        for(var i = 0; i < testCases.size(); i++) {
            var testCase = testCases[i];
            var actual = formatDuration(testCase[:duration]);
            
            logger.debug("assert " + testCase[:expected] + " == " + actual);
            Test.assertEqual(testCase[:expected], actual);
        }
        
        return true;
    }

    (:test)
    function sessionToViewModel_ConvertsSessionToViewModel(logger) {
        // Arrange
        var session = Core.createSession();
        Core.completeSuccessfulClimb(session);
        Core.completeFailedClimb(session);
        
        var duration = new Time.Duration(125);
        var currentTime = session.getStartTime().add(duration);
        
        // Act
        logger.debug("convert session to view model");
        var viewModel = sessionToViewModel(session, currentTime);
        
        // Assert
        var expectedDuration = "02:05";
        var actualDuration = viewModel.getDuration();
        logger.debug("duration: " + expectedDuration + " == " + actualDuration);
        Test.assertEqual(expectedDuration, actualDuration);
        
        var expectedTotalClimbs = "2";
        var actualTotalClimbs = viewModel.getTotalClimbs();
        logger.debug("total climbs: " + expectedTotalClimbs + " == " + actualTotalClimbs);
        Test.assertEqual(expectedTotalClimbs, actualTotalClimbs);
        
        var expectedSuccessfulClimbs = "1";
        var actualSuccessfulClimbs = viewModel.getSuccessfulClimbs();
        logger.debug("successful climbs: " + expectedTotalClimbs + " == " +  actualSuccessfulClimbs);
        Test.assertEqual(expectedSuccessfulClimbs, actualSuccessfulClimbs);

        var expectedRestTime = formatDuration(session.getCurrentRestTime(currentTime));
        var actualRestTime = viewModel.getRestTime();
        logger.debug("rest time: " + expectedRestTime + " == " + actualRestTime);
        Test.assertEqual(expectedRestTime, actualRestTime);
        
        return true;
    }

    (:test)
    function completedSessionToViewModel_ConvertsToViewModel(logger) {
        // Arrange
        var id = 1;
        var startTime = new Time.Moment(1551568192);
        var duration = new Time.Duration(95);
        var endTime = startTime.add(duration);
        var climbs = [
            Core.createSuccessfulClimb(),
            Core.createFailedClimb(),
            Core.createSuccessfulClimb()
        ];

        var session = new Core.CompletedClimbingSession(
            id,
            startTime,
            endTime,
            climbs
        );

        // Act
        logger.debug("create view model");
        var viewModel = completedSessionToViewModel(session);

        // Assert
        var expectedTitle = "2019-3-2";
        var actualTitle = viewModel.getTitle();
        logger.debug("title: " + expectedTitle + " == " + actualTitle);
        Test.assertEqual(expectedTitle, actualTitle);

        var expectedDuration = "01:35";
        var actualDuration = viewModel.getDuration();
        logger.debug("duration: " + expectedDuration + " == " + actualDuration);
        Test.assertEqual(expectedDuration, actualDuration);

        var expectedAttemptedClimbs = "3";
        var actualAttemptedClimbs = viewModel.getAttemptedClimbCount();
        logger.debug("attempted climbs: " + expectedAttemptedClimbs + " == " + actualAttemptedClimbs);
        Test.assertEqual(expectedAttemptedClimbs, actualAttemptedClimbs);

        var expectedSuccessfulClimbs = "2";
        var actualSuccessfulClimbs = viewModel.getSuccessfulClimbCount();
        logger.debug("successful climbs: " + expectedSuccessfulClimbs + " == " + actualSuccessfulClimbs);
        Test.assertEqual(expectedSuccessfulClimbs, actualSuccessfulClimbs);

        var expectedFailedClimbs = "1";
        var actualFailedClimbs = viewModel.getFailedClimbCount();
        logger.debug("failed climbs: " + expectedFailedClimbs + " == " + actualFailedClimbs);
        Test.assertEqual(expectedFailedClimbs, actualFailedClimbs);

        return true;
    }

    (:test)
    function sessionHistoryToViewModel_CreatesAHistoryViewModel(logger) {
        // Arrange
        logger.debug("Create old session");
        var oldSessionStartTime = new Time.Moment(1551568192);
        var oldSessionClimbCount = 4;
        var oldSession = Core.createCompletedSessionWithStartTimeAndClimbCount(
                oldSessionStartTime,
                oldSessionClimbCount
            );

        logger.debug("Create new session");
        var newSessionStartTime = new Time.Moment(1552147264);
        var newSessionClimbCount = 10;
        var newSession = Core.createCompletedSessionWithStartTimeAndClimbCount(
                newSessionStartTime,
                newSessionClimbCount
            );

        var sessions = [oldSession, newSession];

        // Act
        logger.debug("Convert to view model");
        var viewModel = sessionHistoryToViewModel(sessions);

        // Assert
        logger.debug("Title");
        Test.assertEqual("History", viewModel.getTitle());

        logger.debug("Get menu items");
        var menuItems = viewModel.getMenuItems();
        
        var expectedCount = sessions.size();
        var actualCount = menuItems.size();
        logger.debug("size: " + expectedCount + " == " + actualCount);
        Test.assertEqual(expectedCount, actualCount);

        logger.debug("First menu item");
        assertMenuItemMatches(
            logger,
            newSession.getId(),
            "2019-3-9",
            "10 Climbs",
            menuItems[0]
        );

        logger.debug("Second menu item");
        assertMenuItemMatches(
            logger,
            oldSession.getId(),
            "2019-3-2",
            "4 Climbs",
            menuItems[1]
        );

        return true;
    }

    function assertMenuItemMatches(logger, id, label, subLabel, actualItem) {
        var actualId =  actualItem.getId();
        logger.debug("id: " + id + " == " + actualId);
        Test.assertEqual(id, actualId);

        var actualLabel = actualItem.getLabel();
        logger.debug("label: " + label + " == " + actualLabel);
        Test.assertEqual(label, actualLabel);

        var actualSubLabel = actualItem.getSubLabel();
        logger.debug("subLabel: " + subLabel + " == " + actualSubLabel);
        Test.assertEqual(subLabel, actualSubLabel);
    }
}