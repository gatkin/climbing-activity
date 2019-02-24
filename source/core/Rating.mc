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