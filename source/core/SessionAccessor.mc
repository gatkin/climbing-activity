using Toybox.Application.Storage;
using Toybox.Time;
using ClimbingCore as Core;


module ClimbingCore
{
module Storage
{
    // Keys to be used for dictionaries persisted to storage.
    enum {
        RATING_TEXT,
        RATING_TYPE,
        CLIMB_ID,
        CLIMB_START_TIME,
        CLIMB_END_TIME,
        CLIMB_RATING,
        CLIMB_SUCCESS,
        SESSION_ID,
        SESSION_START_TIME,
        SESSION_END_TIME,
        SESSION_CLIMBS,
    }

    // Persists session data to storage.
    class SessionAccessor
    {
        function initialize() {

        }

        // Get the key used to store an array of all completed sessions in storage.
        function getStorageKey() {
            return "sessions";
        }

        // Persists a completed session to storage.
        function saveCompletedSession(session) {
            var sessionList = Storage.getValue(self.getStorageKey());
            if(sessionList == null) {
                sessionList = new [0];
            }

            sessionList.add(sessionToDict(session));
            Storage.setValue(self.getStorageKey(), sessionList);
        }
    }

    // Convert a dictionary that bas been persisted to storage to a completed climb.
    function climbFromDict(climbDict) {
        return new Core.CompletedClimb(
            climbDict[CLIMB_ID],
            new Time.Moment(climbDict[CLIMB_START_TIME]),
            new Time.Moment(climbDict[CLIMB_END_TIME]),
            ratingFromDict(climbDict[CLIMB_RATING]),
            climbDict[CLIMB_SUCCESS]
        );
    }

    // Convert a completed climb to a dictionary that can be persisted to storage.
    function climbToDict(climb) {
        return {
            CLIMB_ID => climb.getId(),

            // Must convert moments to integers so they can be persisted
            CLIMB_START_TIME => climb.getStartTime().value(),
            CLIMB_END_TIME => climb.getEndTime().value(),

            CLIMB_RATING => ratingToDict(climb.getRating()),
            CLIMB_SUCCESS => climb.wasSuccessful(),
        };
    }

    // Convert a dictionary that has been persisted to storage to a rating.
    function ratingFromDict(ratingDict) {
        if(ratingDict[RATING_TYPE] == CLIMB_TYPE_ROPED_CLIMB) {
            return Core.RopedClimbRating.fromText(ratingDict[RATING_TEXT]);
        } else {
            return Core.BoulderRating.fromText(ratingDict[RATING_TEXT]);
        }
    }

    // Convert a rating to a dictionary that can be persisted to storage.
    function ratingToDict(rating) {
        return {
            RATING_TYPE => rating.getClimbType(),
            RATING_TEXT => rating.getText(),
        };
    }

    // Convert a dictionary that has been persisted to storage to a completed session.
    function sessionFromDict(sessionDict) {
        var dictClimbs = sessionDict[SESSION_CLIMBS];
        var climbs = new [dictClimbs.size()];

        for(var i = 0; i < dictClimbs.size(); i++) {
            climbs[i] = climbFromDict(dictClimbs[i]);
        }

        return new Core.CompletedClimbingSession(
            sessionDict[SESSION_ID],
            new Time.Moment(sessionDict[SESSION_START_TIME]),
            new Time.Moment(sessionDict[SESSION_END_TIME]),
            climbs
        );
    }

    // Convert a completed session to a dictionary that can be persisted to storage.
    function sessionToDict(session) {
        var climbs = session.getClimbs();
        var dictClimbs = new [climbs.size()];
        
        for(var i = 0; i < climbs.size(); i++) {
            dictClimbs[i] = climbToDict(climbs[i]);
        }

        return {
            SESSION_ID => session.getId(),

            // Must convert moments to integers so they can be persisted
            SESSION_START_TIME => session.getStartTime().value(),
            SESSION_END_TIME => session.getEndTime().value(),

            SESSION_CLIMBS => dictClimbs,
        };
    }
}
}