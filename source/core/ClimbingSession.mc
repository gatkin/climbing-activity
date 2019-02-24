using Toybox.Time;

module ClimbingCore
{
    const MAX_CLIMBS = 100;
    const DEFAULT_CLIMB_TYPE = CLIMB_TYPE_BOULDERING;

    class ClimbingSession
    {
        private var id;
        private var startTime;
        private var activeClimb;
        private var completedClimbsCount;
        private var successfulClimbsCount;
        private var completedClimbs;

        function initialize(timeStarted) {
            startTime = timeStarted;
            id = startTime.value();
            activeClimb = null;
            completedClimbsCount = 0;
            successfulClimbsCount = 0;
            completedClimbs = new [MAX_CLIMBS];
        }

        function cancelActiveClimb() {
            self.activeClimb = null;
        }

        function completeClimbAsFailure(endTime, rating) {
            var completedClimb = self.activeClimb.completeAsFailure(endTime, rating);
            self.addCompletedClimb(completedClimb);
        }

        function completeClimbAsSuccess(endTime, rating) {
            var completedClimb = self.activeClimb.completeAsSuccess(endTime, rating);
            self.successfulClimbsCount = self.successfulClimbsCount + 1;
            self.addCompletedClimb(completedClimb);
        }

        function getActiveClimb() {
            return self.activeClimb;
        }

        function getCompletedClimbs() {
            return self.completedClimbs;
        }

        // Get duration since the last completed climb.
        function getCurrentRestTime(currentTime) {
            if(self.activeClimb != null) {
                return new Time.Duration(0);
            }

            if(self.completedClimbsCount == 0) {
                return currentTime.subtract(self.startTime);
            }

            var lastClimb = self.getLastClimb();
            return currentTime.subtract(lastClimb.getEndTime());
        }

        function getId() {
            return self.id;
        }

        function getLastClimbType() {
            if(self.completedClimbsCount == 0) {
                return DEFAULT_CLIMB_TYPE;
            }

            var lastClimb = self.getLastClimb();
            return lastClimb.getClimbType();
        }

        function getNumberOfCompletedClimbs() {
            return self.completedClimbsCount;
        }

        function getNumberOfSuccessfulClimbs() {
            return self.successfulClimbsCount;
        }

        function getStartTime() {
            return self.startTime;
        }

        function startNewClimb(startTime) {
            self.activeClimb = new ActiveClimb(startTime);
        }

        private function addCompletedClimb(completedClimb) {
            self.completedClimbs[self.completedClimbsCount] = completedClimb;
            self.completedClimbsCount = self.completedClimbsCount + 1;
            self.activeClimb = null;
        }

        private function getLastClimb() {
            return self.completedClimbs[self.completedClimbsCount - 1];
        }
    }
}