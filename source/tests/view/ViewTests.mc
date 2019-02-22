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
	function sessionViewModelFromSession(logger) {
		// Arrange
		var startTime = Time.now();
		var timeProvider = new Core.MockTimeProvider(startTime);
		var session = Core.createSessionWithTimeProvider(timeProvider);
		
		Core.completeSuccessfulClimb(session);
		Core.completeFailedClimb(session);
		
		var duration = new Time.Duration(60);
		timeProvider.setCurrentTime(startTime.add(duration));
		
		// Act
		logger.debug("convert session to view model");
		var viewModel = sessionToViewModel(session);
		
		// Assert
		logger.debug("correct duration");
		Core.assertDurationsAreEqual(duration, viewModel.getDuration());
		
		var actualTotalClimbs = viewModel.getTotalClimbs();
		logger.debug("correct total climbs: 2 == " + actualTotalClimbs);
		Test.assertEqual(2, actualTotalClimbs);
		
		var actualSuccessfulClimbs = viewModel.getSuccessfulClimbs();
		logger.debug("correct successulf climbs: 1 == " +  actualSuccessfulClimbs);
		Test.assertEqual(1, actualSuccessfulClimbs);
		
		return true;
	}
}