module ClimbingCore
{
    enum
    {
        CLIMB_TYPE_BOULDERING,
        CLIMB_TYPE_ROPED_CLIMB,
    }

    class BoulderRating
    {
        private var rating;

        function initialize(value) {
            rating = value;
        }

        // Create a new BoulderRating from the rating text.
        static function fromText(text) {
            var mapping = {
                "V0" => :V0,
                "V1" => :V1,
                "V2" => :V2,
                "V3" => :V3,
                "V4" => :V4,
                "V5" => :V5,
                "V6" => :V6,
                "V7" => :V7,
                "V8" => :V8,
                "V9" => :V9,
                "V10" => :V10,
            };

            var rating = mapping.get(text);
            if(rating == null) {
                rating = :V0;
            }

            return new BoulderRating(rating);
        }

        function equals(other) {
            if(other == null) {
                return false;
            }

            if(!(other instanceof BoulderRating)) {
                return false;
            }

            return nullableEquals(self.getRating(), other.getRating());
        }

        function getClimbType() {
            return CLIMB_TYPE_BOULDERING;
        }

        function getRating() {
            return self.rating;
        }

        function getText() {
            return rating.toString();
        }
    }

    class RopedClimbRating
    {
        private var rating;

        function initialize(value) {
            rating = value;
        }

        // Create a new RopedClimbRating from the rating text.
        static function fromText(text) {
            var mapping = {
                "5.6" => :Y56,
                "5.7" => :Y57,
                "5.8" => :Y58,
                "5.9" => :Y59,
                "5.10A" => :Y510A,
                "5.10B" => :Y510B,
                "5.10C" => :Y510C,
                "5.10D" => :Y510D,
                "5.11A" => :Y511A,
                "5.11B" => :Y511B,
                "5.11C" => :Y511C,
                "5.11D" => :Y511D,
                "5.12A" => :Y512A,
            };

            var rating = mapping.get(text);
            if(rating == null) {
                rating = :Y56;
            }

            return new RopedClimbRating(rating);
        }

        function equals(other) {
            if(other == null) {
                return false;
            }

            if(!(other instanceof RopedClimbRating)) {
                return false;
            }

            return nullableEquals(self.getRating(), other.getRating());
        }

        function getClimbType() {
            return CLIMB_TYPE_ROPED_CLIMB;
        }

        function getRating() {
            return self.rating;
        }

        function getText() {
            switch(self.rating) {
                case :Y56:
                    return "5.6";
                break;

                case :Y57:
                    return "5.7";
                break;

                case :Y58:
                    return "5.8";
                break;

                case :Y59:
                    return "5.9";
                break;

                case :Y510A:
                    return "5.10A";
                break;

                case :Y510B:
                    return "5.10B";
                break;

                case :Y510C:
                    return "5.10C";
                break;

                case :Y510D:
                    return "5.10D";
                break;

                case :Y511A:
                    return "5.11A";
                break;

                case :Y511B:
                    return "5.11B";
                break;

                case :Y511C:
                    return "5.11C";
                break;

                case :Y511D:
                    return "5.11D";
                break;

                case :Y512A:
                    return "5.12A";
                break;

                default:
                    return "Invalid";
                break;
            }
        }
    }
}