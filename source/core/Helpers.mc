module ClimbingCore
{
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