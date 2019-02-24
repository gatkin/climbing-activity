using Toybox.Time;

module ClimbingCore
{
    const DEFAULT_CLIMB_TYPE = CLIMB_TYPE_BOULDERING;

    class ClimbingSession
    {
        private var id;
        private var startTime;
        private var activeClimb;
        private var successfulClimbsCount;
        private var completedClimbs;

        function initialize(timeStarted) {
            startTime = timeStarted;
            id = startTime.value();
            activeClimb = null;
            successfulClimbsCount = 0;
            completedClimbs = new [0];
        }

        function cancelActiveClimb() {
            self.activeClimb = null;
        }

        // Complete the session.
        function complete(sessionEndTime) {
            return new CompletedClimbingSession(
                self.id,
                self.startTime,
                sessionEndTime,
                self.completedClimbs
            );
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

            if(!self.anyCompletedClimbs()) {
                return currentTime.subtract(self.startTime);
            }

            var lastClimb = self.getLastClimb();
            return currentTime.subtract(lastClimb.getEndTime());
        }

        function getId() {
            return self.id;
        }

        function getLastClimbType() {
            if(!self.anyCompletedClimbs()) {
                return DEFAULT_CLIMB_TYPE;
            }

            var lastClimb = self.getLastClimb();
            return lastClimb.getClimbType();
        }

        function getNumberOfCompletedClimbs() {
            return self.completedClimbs.size();
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
            self.completedClimbs.add(completedClimb);
            self.activeClimb = null;
        }

        private function anyCompletedClimbs() {
            return self.completedClimbs.size() > 0;
        }

        private function getLastClimb() {
            return self.completedClimbs[self.completedClimbs.size() - 1];
        }
    }

    class CompletedClimbingSession
    {
        private var id;
        private var startTime;
        private var endTime;
        private var climbs;

        function initialize(
            sessionId,
            timeStarted,
            timeEnded,
            completedClimbs
        )
        {
            id = sessionId;
            startTime = timeStarted;
            endTime = timeEnded;
            climbs = completedClimbs;
        }

        function getClimbs() {
            return self.climbs;
        }

        function getEndTime() {
            return self.endTime;
        }

        function getId() {
            return self.id;
        }

        function getStartTime() {
            return self.startTime;
        }
    }
}