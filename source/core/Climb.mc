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