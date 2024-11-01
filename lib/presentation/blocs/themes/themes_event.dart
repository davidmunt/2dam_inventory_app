abstract class ThemeEvent {
  const ThemeEvent();
}

class ThemeChanged extends ThemeEvent {
  final int color;
  final bool darkmode;
  final String fontFamily;
  const ThemeChanged(this.color, this.darkmode, this.fontFamily);
}