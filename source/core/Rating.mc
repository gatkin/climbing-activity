module ClimbingCore
{
    enum
    {
        CLIMB_TYPE_BOULDERING,
        CLIMB_TYPE_ROPE_CLIMB,
    }

    class BoulderRating
    {
        private var rating;

        function initialize(value) {
            rating = value;
        }

        function getClimbType() {
            return CLIMB_TYPE_BOULDERING;
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

        function getClimbType() {
            return CLIMB_TYPE_ROPE_CLIMB;
        }

        function getText() {
            switch(self.rating) {
                case 0:
                    return "5.6";
                break;

                case 1:
                    return "5.7";
                break;

                case 2:
                    return "5.8";
                break;

                case 3:
                    return "5.9";
                break;

                case 4:
                    return "5.10A";
                break;

                case 5:
                    return "5.10B";
                break;

                case 6:
                    return "5.10C";
                break;

                case 7:
                    return "5.10D";
                break;

                case 8:
                    return "5.11A";
                break;

                case 9:
                    return "5.11B";
                break;

                case 10:
                    return "5.11C";
                break;

                case 11:
                    return "5.11D";
                break;

                case 12:
                    return "5.12A";
                break;

                default:
                    return "Invalid";
                break;
            }
        }
    }
}