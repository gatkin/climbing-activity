module ClimbingView
{
	class SessionViewModel
	{
		private var elapsedDuration;
		private var totalClimbs;
		private var successfulClimbs;
		
		function initialize(
			timeElapsed,
			climbsTotal,
			climbsSuccessful
		)
		{
			elapsedDuration = timeElapsed;
			totalClimbs = climbsTotal;
			successfulClimbs = climbsSuccessful;
		}
		
		function getDuration() {
			return self.elapsedDuration;
		}
		
		function getSuccessfulClimbs() {
			return self.successfulClimbs;
		}
		
		function getTotalClimbs() {
			return self.totalClimbs;
		}
	}
	
	function formatDuration(duration) {
		var timeField1;
    	var timeField2;
    	var totalSeconds = duration.value();
		var minutes = (totalSeconds / 60).toNumber();
		
		if(minutes >= 60) {
			// Show hours:minutes
			timeField1 = (minutes / 60).toNumber().toString(); // Convert to hours
			minutes = minutes % 60;
			
			// Pad with a leading 0 if less than 10
			timeField2 = (minutes < 10) ? ("0" + minutes.toString()) : (minutes.toString());
		} else {
			// Show minutes:seconds
			timeField1 = (minutes < 10) ? ("0" + minutes.toString()) : (minutes.toString());
			
			var seconds = (totalSeconds % 60).toNumber();
			timeField2 = (seconds < 10) ? ("0" + seconds.toString()) : (seconds.toString());
		}
		
		return timeField1 + ":" + timeField2;
	}
	
	function sessionToViewModel(climbingSession) {
		var elapsedDuration = climbingSession.getElapsedDuration();
		var totalClimbs = climbingSession.getNumberOfCompletedClimbs();
		var successfulClimbs = climbingSession.getNumberOfSuccessfulClimbs();
		
		return new SessionViewModel(elapsedDuration, totalClimbs, successfulClimbs);
	}
}