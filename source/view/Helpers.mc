using Toybox.Attention;

module ClimbingView
{
    function vibrateWatch() {
        Attention.vibrate([new Attention.VibeProfile(50, 1000)]);
        Attention.playTone(Attention.TONE_START);
    }
}