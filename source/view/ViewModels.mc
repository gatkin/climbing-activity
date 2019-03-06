using Toybox.Time;
using Toybox.Time.Gregorian;


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

    class CompletedSessionViewModel
    {
        private var title;
        private var duration;
        private var attemptedClimbCount;
        private var successfulClimbCount;
        private var failedClimbCount;

        function initialize(
            titleOfSession,
            sessionDuration,
            numSuccessClimbs,
            numFailedClimbs
        )
        {
            title = titleOfSession;
            duration = sessionDuration;
            attemptedClimbCount = (numSuccessClimbs + numFailedClimbs).toString();
            successfulClimbCount = numSuccessClimbs;
            failedClimbCount = numFailedClimbs;
        }

        function getAttemptedClimbCount() {
            return self.attemptedClimbCount;
        }

        function getDuration() {
            return self.duration;
        }

        function getFailedClimbCount() {
            return self.successfulClimbCount.toString();
        }

        function getSuccessfulClimbCount() {
            return self.failedClimbCount.toString();
        }

        function getTitle() {
            return self.title;
        }
    }

    function completedSessionToViewModel(session) {
        var sessionTitle = formatMoment(session.getStartTime());
        var duration = formatDuration(session.getDuration());
        
        return new CompletedSessionViewModel(
            sessionTitle,
            duration,
            session.getFailedClimbCount(),
            session.getSuccessfulClimbCount()
        );
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

    // Format a Moment as YYYY-MM-DD (e.g. 2019-2-21).
    function formatMoment(moment) {
        var date = Gregorian.info(moment, Time.FORMAT_SHORT);
        return date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
    }
    
    function sessionToViewModel(climbingSession, currentTime) {
        var elapsedDuration = currentTime.subtract(climbingSession.getStartTime());
        
        return new SessionViewModel(
            formatDuration(elapsedDuration),
            formatDuration(climbingSession.getCurrentRestTime(currentTime)),
            climbingSession.getNumberOfCompletedClimbs().toString(),
            climbingSession.getNumberOfSuccessfulClimbs().toString()
        );
    }
}