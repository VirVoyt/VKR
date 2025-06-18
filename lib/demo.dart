library app_demo;

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:io';
part 'api.dart';
part 'OrdersPage.dart';
part 'loginScreen.dart';
part 'companiesCart.dart';
part 'models.dart';
part 'theme.dart';
part 'authService.dart';
