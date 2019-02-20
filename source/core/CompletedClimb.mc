module ClimbingCore
{
	class CompletedClimb
	{
		private var id;
		private var startTime;
		private var endTime;
		private var success;
		
		function initialize(
			identifier,
			start,
			end,
			successful
		)
		{
			id = identifier;
			startTime = start;
			endTime = end;
			success = successful;
		}
		
		function getDuration() {
			return self.endTime.subtract(self.startTime);
		}
		
		function wasSuccessful() {
			return self.success;
		}
	}
}