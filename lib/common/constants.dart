import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';
const API_KEY = 'api_key=5bf2d7ae486e4d2ec78c1eeaf78da2ce';
const BASE_URL = 'https://api.themoviedb.org/3';
const TV_SHOW_ID = 'tv_show_id';
const SEASON_NUMBER = 'season_number';
const EPISODE_NUMBER = 'episode_number';

// colors
const Color primaryColor = Color(0xFF73c3f9);
const Color primaryVariantColor = Color(0xFF4c8eba);
const Color secondaryColor = Color(0xFFD3DCFB);
const Color secondaryVariantColor = Color(0xFF9cb1f4);
const Color darkBlueColor = Color(0xFF2A428C);
const Color yellow = Color(0xFFffcd3c);

// text style
final TextStyle heading5 =
    GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w400);
final TextStyle heading6 = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15);
final TextStyle subtitle = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15);
final TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.25);

// text theme
final textTheme = TextTheme(
  headline5: heading5,
  headline6: heading6,
  subtitle1: subtitle,
  bodyText2: bodyText,
);

const colorScheme = ColorScheme(
  primary: Colors.white,
  primaryVariant: primaryVariantColor,
  secondary: secondaryColor,
  secondaryVariant: secondaryVariantColor,
  surface: primaryColor,
  background: primaryColor,
  error: Colors.red,
  onPrimary: primaryColor,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onBackground: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
