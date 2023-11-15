import 'package:flutter/material.dart';

double phoneSize = 550;
double tabletSize = 1000;
// commen colors
Color whiteColor = Colors.white;
Color blackColor = Colors.black;
Color mainGold = const Color.fromRGBO(243, 180, 0, 1);
Color secondaryGold = const Color.fromARGB(157, 207, 155, 12);

// light theme colors
Color lightShadow = const Color.fromARGB(255, 204, 203, 203);
Color lightGrey = const Color.fromARGB(255, 237, 235, 235);

// dark theme colors
Color darkBacgroundColor = const Color.fromARGB(255, 55, 55, 55);
Color darkForGroundColor = const Color.fromRGBO(54, 54, 54, 1);
Color darkShadowColor = const Color.fromARGB(255, 32, 32, 32);

// themes
ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        background: whiteColor,
        onBackground: lightGrey,
        shadow: lightShadow,
        primary: mainGold,
        secondary: secondaryGold));

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        background: darkBacgroundColor,
        onBackground: darkForGroundColor,
        primary: mainGold,
        secondary: secondaryGold,
        shadow: darkShadowColor));

// constant strings
String userDataKey = 'userDataKey';

// api info
const apiKey = 'e11cff04b1fcf50079f6918e5199d691';
const imdbKey = 'k_b4zpyb19';
const imagebase = 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2';
const trending =
    'https://api.themoviedb.org/3/trending/all/day?api_key=$apiKey&language=';
const upcoming =
    'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=';
const pop =
    'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=';
const popularTv =
    'https://api.themoviedb.org/3/tv/popular?api_key=$apiKey&language=';
const top =
    'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=';
const topTv =
    'https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey&language=';
const search =
    'https://api.themoviedb.org/3/search/multi?api_key=$apiKey&language=';
