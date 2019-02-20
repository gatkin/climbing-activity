using Toybox.Time;

module ClimbingCore
{
	const MAX_CLIMBS = 100;

	class ClimbingSession
	{
		private var id;
		private var startTime;
		private var activeClimb;
		private var completedClimbsCount;
		private var completedClimbs;

		function initialize(start) {
			startTime = start;
			id = start.value();
			activeClimb = null;
			completedClimbsCount = 0;
			completedClimbs = new [MAX_CLIMBS];
		}

		function completeClimbAsFailure(rating) {
			var completedClimb = self.activeClimb.completeAsFailure(Time.now(), rating);
			self.addCompletedClimb(completedClimb);
		}

		function completeClimbAsSuccess(rating) {
			var completedClimb = self.activeClimb.completeAsSuccess(Time.now(), rating);
			self.addCompletedClimb(completedClimb);
		}

		function getActiveClimb() {
			return self.activeClimb;
		}

		function getCompletedClimbs() {
			return self.completedClimbs;
		}

		function getId() {
			return self.id;
		}

		function getNumberOfCompletedClimbs() {
			return completedClimbsCount;
		}

		function getStartTime() {
			return self.startTime;
		}

		function startNewClimb() {
			self.activeClimb = new ActiveClimb(Time.now());
		}

		private function addCompletedClimb(completedClimb) {
			self.completedClimbs[self.completedClimbsCount] = completedClimb;
			self.completedClimbsCount = self.completedClimbsCount + 1;
			self.activeClimb = null;
		}
	}
}