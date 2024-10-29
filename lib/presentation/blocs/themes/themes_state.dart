import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final int colorTheme;
  final bool darkMode;

  const ThemeState({this.colorTheme = 0, this.darkMode = false});

  ThemeState copyWith({
    int? colorTheme,
    bool? darkMode,
  }) =>
      ThemeState(
        colorTheme: colorTheme ?? this.colorTheme,
        darkMode: darkMode ?? this.darkMode,
      );

  @override
  List<Object> get props => [colorTheme, darkMode];
}