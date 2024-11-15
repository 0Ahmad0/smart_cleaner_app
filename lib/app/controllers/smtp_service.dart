import 'dart:developer';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SmtpService{
  static String _email='support@smart_cleaner.com';
  static String _nameTeam='Smart Cleaner';
 static Future<void> sendEmail() async {
   // final smtpServer = gmail('your-email@gmail.com', 'your-email-password');
   final message = Message()
     ..from = Address('support@vivafone.net', 'Vivafone Support')
     ..recipients.add('mr.ahmadmriwed@gmail.com')
     ..subject = 'Test Email'
     ..text = 'This is a test email';

   // تفاصيل SMTP من Mailtrap
   final smtpServer = SmtpServer(
     'smtp.mailtrap.io',  // Mailtrap SMTP server
     port: 587,            // Mailtrap SMTP port
     username: '8de61998705b29',  // Mailtrap username
     password: '6f1d91918dcfac',  // Mailtrap password
   );

   try {
     final sendReport = await send(message, smtpServer);
     log('Message sent: ${sendReport.toString()}');
   } on MailerException catch (e) {
     log('Message not sent: $e');
   }
 }
  static sendCode({
    String? name,
    required String code,
    required String email,
  }) async {
    final message = Message()
      ..from = Address('$_email', '$_nameTeam Support')
      ..recipients.add(email)
      ..subject = 'Confirmation Code for Task Cancellation'
      ..html = '''
      <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; }
          .container { width: 80%; margin: auto; }
          .header { background-color: #f4f4f4; padding: 20px; text-align: center; }
          .logo { width: 150px; }
          .content { margin-top: 20px; }
          .footer { margin-top: 20px; padding: 10px; background-color: #f4f4f4; text-align: center; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="content">
            <p>Hello,</p>
            <p>You have requested to cancel the task for the robot named <strong>${name ?? "Unnamed Robot"}</strong>.</p>
            <p>Please use the confirmation code below to proceed with the cancellation:</p>
            <h2 style="color: #FF0000; text-align: center;">$code</h2>
            <p>If you did not make this request, please ignore this email or contact support immediately.</p>
            <p>Best regards,</p>
            <p>The Smart Cleaner Team</p>
          </div>
          <div class="footer">
            <p>${_nameTeam} Inc. | 1234 Address St, City, Country</p>
            <p><a href="mailto:$_email">support@smart_cleaner.com</a></p>
          </div>
        </div>
      </body>
      </html>
      ''';

    // تفاصيل SMTP من Mailtrap
    final smtpServer = SmtpServer(
      'smtp.mailtrap.io', // Mailtrap SMTP server
      port: 587, // Mailtrap SMTP port
      username: 'a28b7c1203d433', // Mailtrap username
      password: 'c9198cacd14bd1', // Mailtrap password
    );

    // تفاصيل SMTP من Mailtrap
    // final smtpServer = SmtpServer(
    //   'smtp.mailtrap.io', // Mailtrap SMTP server
    //   port: 587, // Mailtrap SMTP port
    //   username: '8de61998705b29', // Mailtrap username
    //   password: '6f1d91918dcfac', // Mailtrap password
    // );
    try {
      final sendReport = await send(message, smtpServer);
      log('Message sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      log('Message not sent: $e');
    }
  }

}

//   <div class="header">
//             <img src="https://firebasestorage.googleapis.com/v0/b/smart-cleaner-app-cb462.appspot.com/o/logo.png?alt=media&token=866cbb23-2b7a-416a-8b3f-c4d79dc7cf7c" alt="Smart Cleaner Logo" class="logo" />
//             <h1>Task Cancellation Confirmation</h1>
//           </div>