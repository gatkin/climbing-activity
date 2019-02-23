module ClimbingView
{
    class SessionViewModel
    {
        private var duration;
        private var restTime;
        private var totalClimbs;
        private var successfulClimbs;
        
        function initialize(
            elapsedDuration,
            restDuration,
            climbsTotal,
            climbsSuccessful
        )
        {
            duration = elapsedDuration;
            restTime = restDuration;
            totalClimbs = climbsTotal;
            successfulClimbs = climbsSuccessful;
        }
        
        function getDuration() {
            return self.duration;
        }

        function getRestTime() {
            return self.restTime;
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
    
    function sessionToViewModel(climbingSession, currentTime) {
        var elapsedDuration = currentTime.subtract(climbingSession.getStartTime());
        
        return new SessionViewModel(
            elapsedDuration,
            climbingSession.getCurrentRestTime(currentTime),
            climbingSession.getNumberOfCompletedClimbs(),
            climbingSession.getNumberOfSuccessfulClimbs()
        );
    }
}