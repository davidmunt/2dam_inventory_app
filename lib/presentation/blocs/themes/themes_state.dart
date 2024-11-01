import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final int colorTheme;
  final bool darkMode;
  final String fontFamily;

  const ThemeState({this.colorTheme = 0, this.darkMode = false, this.fontFamily = "Roboto"});

  ThemeState copyWith({
    int? colorTheme,
    bool? darkMode,
    String? fontFamily,
  }) =>
      ThemeState(
        colorTheme: colorTheme ?? this.colorTheme,
        darkMode: darkMode ?? this.darkMode,
        fontFamily: fontFamily ?? this.fontFamily,
      );

  @override
  List<Object> get props => [colorTheme, darkMode, fontFamily];
}