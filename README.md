<!doctype html>
<html lang="ar" dir="rtl">
<head>
  <meta charset="utf-8">
  <title>router-login-ar 🚀 | إدراك</title>
  <meta name="description" content="سكربت بسيط لفتح صفحة إعدادات الراوتر مباشرة على ويندوز أو لينكس/ماك.">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link rel="canonical" href="https://idraaak.com/كيفية-الدخول-على-الراوتر/" />
</head>
<body>
<div dir="rtl" align="right">

# router-login-ar 🚀

سكربت بسيط يفتح صفحة إعدادات الراوتر بنقرة واحدة:

| النظام | الملف |
|--------|-------|
| Windows | `router-login.bat` |
| Linux / macOS | `router-login.sh` |

## طريقة الاستخدام
1. فعّل الصلاحيات (`chmod +x router-login.sh` على لينكس).
2. انقر مزدوجًا على الملف أو شغّله من الطرفيّة.  
3. يكتشف السكربت عنوان البوابة الافتراضية ويفتح المتصفّح عليها.  
4. بديلًا عن ذلك يمكنك تمرير IP يدويًّا:  
   ```bash
   router-login.bat 192.168.0.1
   ./router-login.sh 192.168.0.1
