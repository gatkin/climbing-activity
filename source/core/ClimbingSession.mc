using Toybox.Time;

module ClimbingCore
{
	const MAX_CLIMBS = 100;

	class ClimbingSession
	{
		private var id;
		private var timeProvider;
		private var startTime;
		private var activeClimb;
		private var completedClimbsCount;
		private var successfulClimbsCount;
		private var completedClimbs;
		
		function initialize(timeSource) {
			timeProvider = timeSource;
			startTime = timeSource.now();
			id = startTime.value();
			activeClimb = null;
			completedClimbsCount = 0;
			successfulClimbsCount = 0;
			completedClimbs = new [MAX_CLIMBS];
		}

		function completeClimbAsFailure(rating) {
			var completedClimb = self.activeClimb.completeAsFailure(self.timeProvider.now(), rating);
			self.addCompletedClimb(completedClimb);
		}

		function completeClimbAsSuccess(rating) {
			var completedClimb = self.activeClimb.completeAsSuccess(self.timeProvider.now(), rating);
			self.successfulClimbsCount = self.successfulClimbsCount + 1;
			self.addCompletedClimb(completedClimb);
		}

		function getActiveClimb() {
			return self.activeClimb;
		}

		function getCompletedClimbs() {
			return self.completedClimbs;
		}

		function getElapsedDuration() {
			return self.timeProvider.now().subtract(self.startTime);
		}

		function getId() {
			return self.id;
		}

		function getNumberOfCompletedClimbs() {
			return completedClimbsCount;
		}

		function getNumberOfSuccessfulClimbs() {
			return self.successfulClimbsCount;
		}

		function getStartTime() {
			return self.startTime;
		}

		function startNewClimb() {
			self.activeClimb = new ActiveClimb(self.timeProvider.now());
		}

		private function addCompletedClimb(completedClimb) {
			self.completedClimbs[self.completedClimbsCount] = completedClimb;
			self.completedClimbsCount = self.completedClimbsCount + 1;
			self.activeClimb = null;
		}
	}
}