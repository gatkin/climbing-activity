module ClimbingCore
{
	class ActiveClimb
	{
		private var id;
		private var startTime;
		
		function initialize(start) {
			startTime = start;
			id = start.value();
		}
		
		function completeAsFailure(endTime, rating) {
			return new CompletedClimb(
				id, startTime, endTime, rating, false
			);
		}

		function completeAsSuccess(endTime, rating) {
			return new CompletedClimb(
				id, startTime, endTime, rating, true
			);
		}
		
		function getId() {
			return self.id;
		}
		
		function getStartTime() {
			return self.startTime;
		}
	}
}