using Toybox.Test;


module ClimbingCore
{
    (:test)
    function boulderRatingUsesVScale(logger) {
        var test_cases = [
            {:value => 0, :display => "V0"},
            {:value => 1, :display => "V1"},
            {:value => 2, :display => "V2"},
            {:value => 3, :display => "V3"},
            {:value => 4, :display => "V4"},
            {:value => 5, :display => "V5"},
            {:value => 6, :display => "V6"},
            {:value => 7, :display => "V7"},
            {:value => 8, :display => "V8"},
            {:value => 9, :display => "V9"},
            {:value => 10, :display => "V10"},
        ];

        for(var i = 0; i < test_cases.size(); i++) {
            var test_case = test_cases[i];

            logger.debug("boulder rating of value: " + test_case[:value]);
            var rating = new BoulderRating(test_case[:value]);

            logger.debug("climb type is bouldering");
            Test.assertEqual(CLIMB_TYPE_BOULDERING, rating.getClimbType());

            var expectedText = test_case[:display];
            var actualText = rating.getText();
            logger.debug("assert " + expectedText + " == " + actualText);
            Test.assertEqual(expectedText, actualText);
        }

        return true;
    }

    (:test)
    function ropedClimbRatingUsesYosemiteDecimalScale(logger) {
        var test_cases = [
            {:value => 0, :display => "5.6"},
            {:value => 1, :display => "5.7"},
            {:value => 2, :display => "5.8"},
            {:value => 3, :display => "5.9"},
            {:value => 4, :display => "5.10A"},
            {:value => 5, :display => "5.10B"},
            {:value => 6, :display => "5.10C"},
            {:value => 7, :display => "5.10D"},
            {:value => 8, :display => "5.11A"},
            {:value => 9, :display => "5.11B"},
            {:value => 10, :display => "5.11C"},
            {:value => 11, :display => "5.11D"},
            {:value => 12, :display => "5.12A"},
        ];

        for(var i = 0; i < test_cases.size(); i++) {
            var test_case = test_cases[i];

            logger.debug("roped climb rating of value: " + test_case[:value]);
            var rating = new RopedClimbRating(test_case[:value]);

            logger.debug("climb type is roped climb");
            Test.assertEqual(CLIMB_TYPE_ROPE_CLIMB, rating.getClimbType());

            var expectedText = test_case[:display];
            var actualText = rating.getText();
            logger.debug("assert " + expectedText + " == " + actualText);
            Test.assertEqual(expectedText, actualText);
        }

        return true;
    }
}