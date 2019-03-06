module ClimbingCore
{
    // Check whether two Moment objects are equal
    function momentsAreEqual(a, b) {
        if((a == null) && (b == null)) {
            return true;
        } else if((a != null) && (b != null)) {
            return a.compare(b) == 0;
        } else {
            return false;
        }
    }

    // Check whether two, possibly null values, are equal.
    function nullableEquals(a, b) {
        if((a == null) && (b == null)) {
            return true;
        } else if((a != null) && (b != null)) {
            return a.equals(b);
        } else {
            return false;
        }
    }
}