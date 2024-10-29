abstract class ThemeEvent {
  const ThemeEvent();
}

class ThemeChanged extends ThemeEvent {
  final int color;
  final bool darkmode;
  const ThemeChanged(this.color, this.darkmode);
}