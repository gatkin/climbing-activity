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
        
        var duration = new Time.Duration(60);
        var currentTime = session.getStartTime().add(duration);
        
        // Act
        logger.debug("convert session to view model");
        var viewModel = sessionToViewModel(session, currentTime);
        
        // Assert
        logger.debug("correct duration");
        Core.assertDurationsAreEqual(duration, viewModel.getDuration());
        
        var actualTotalClimbs = viewModel.getTotalClimbs();
        logger.debug("correct total climbs: 2 == " + actualTotalClimbs);
        Test.assertEqual(2, actualTotalClimbs);
        
        var actualSuccessfulClimbs = viewModel.getSuccessfulClimbs();
        logger.debug("correct successulf climbs: 1 == " +  actualSuccessfulClimbs);
        Test.assertEqual(1, actualSuccessfulClimbs);

        logger.debug("correct rest time");
        var expectedRestTime = session.getCurrentRestTime(currentTime);
        Core.assertDurationsAreEqual(expectedRestTime, viewModel.getRestTime());
        
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
        var expectedDate = "2019-3-2";
        var actualDate = viewModel.getDate();
        logger.debug("date: " + expectedDate + " == " + actualDate);
        Test.assertEqual(expectedDate, actualDate);

        var expectedDuration = "01:35";
        var actualDuration = viewModel.getDuration();
        logger.debug("duration: " + expectedDuration + " == " + actualDuration);
        Test.assertEqual(expectedDuration, actualDuration);

        var expectedSuccessfulClimbs = 2;
        var actualSuccessfulClimbs = viewModel.getSuccessfulClimbCount();
        logger.debug("successful climbs: " + expectedSuccessfulClimbs + " == " + actualSuccessfulClimbs);
        Test.assertEqual(expectedSuccessfulClimbs, actualSuccessfulClimbs);

        var expectedFailedClimbs = 1;
        var actualFailedClimbs = viewModel.getFailedClimbCount();
        logger.debug("failed climbs: " + expectedFailedClimbs + " == " + actualFailedClimbs);
        Test.assertEqual(expectedFailedClimbs, actualFailedClimbs);

        return true;
    }
}