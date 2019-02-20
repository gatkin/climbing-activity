module ClimbingCore
{
	class CompletedClimb
	{
		private var id;
		private var startTime;
		private var endTime;
		private var rating;
		private var success;
		
		function initialize(
			identifier,
			start,
			end,
			climbRating,
			successful
		)
		{
			id = identifier;
			startTime = start;
			endTime = end;
			rating = climbRating;
			success = successful;
		}
		
		function getDuration() {
			return self.endTime.subtract(self.startTime);
		}

		function getId() {
			return self.id;
		}

		function getRating() {
			return self.rating;
		}
		
		function wasSuccessful() {
			return self.success;
		}
	}
}