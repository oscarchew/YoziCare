# Solution Challenge - YoziCare
## Introduction
Our platform provides a convenient way for people to assess their risk of chronic kidney disease (CKD) and keep track of their dietary habits with automated analysis. Patients can easily record their food intake and receive personalized insights, while also accessing professional support for any kidney-related concerns.

Demo Video: https://www.youtube.com/watch?v=ZiV0I_lN80E

## Features and functionalities

| Chronic kidney disease map | Chronic kidney disease statistics | Chatbot |
| :--: | :--: | :--: |
| <video src='https://github.com/oscarchew/kidney/assets/100932226/448ce604-95cd-4fc1-8233-c5e1e625b26c' width=150/> | <video src='https://github.com/oscarchew/kidney/assets/100932226/2eb6772c-c73e-4345-a257-b08cf16c312b' width=150/> | <video src='https://github.com/oscarchew/kidney/assets/100932226/c22d3b57-791b-4998-8cd9-3924eaff44b4' width=150/> |
| **Food composition analysis** | **User basic data** | **Localization** |
| <video src='https://github.com/oscarchew/kidney/assets/100932226/4f132554-e2f0-437b-89b2-0ed38999c94a' width=150/> | <img src='https://github.com/oscarchew/kidney/assets/100932226/cf08cb92-5d90-449d-982e-433e31b1b661' width=280/> | <video src='https://github.com/oscarchew/kidney/assets/100932226/37873dc9-1e4a-4b81-b3b4-a4e5be48ab8f' width=150/> |

### Chronic kidney disease map

To make it easier for kidney disease patients to travel throughout Taiwan, we have created a map of dialysis centers that enables patients to quickly locate the nearest center in each county or city. We are using the Google Maps API to provide distance estimation and navigation services, and have also added location-specific information to facilitate appointment scheduling and contact.

### Chronic kidney disease statistics
- We conduct a preliminary assessment based on the user's family medical history, medication use, and lifestyle habits.
- Using indicators such as glomerular filtration rate (GFR) and creatinine levels, we determine the stage of the disease and provide dietary recommendations based on the results (linked to the first point for condition identification). In addition to using Firebase or GCP APIs for analysis, we can also display changes in health status over time using line graphs.
- Water intake is especially important for kidney disease patients, as it is highly correlated with urine output. Both can be uploaded to Firestore and relevant notifications can be pushed to Google Assistant via Firebase Cloud Messaging (FCM).

### Chatbot

Users can ask questions related to kidney disease, and our chatbot will provide answers during the conversation. (e.g. "What are the symptoms of kidney disease?")

### Food Composition Analysis

Users can upload a photo of their food or choose an existing photo from their gallery to analyze it on Google Cloud Run. The platform will then determine the composition of the food and analyze whether it's suitable for individuals with kidney disease to consume. The results of the analysis will be displayed for the user.

### Localization

Most Taiwanese people are more familiar to Mandarin, and the elderlies may have problems with the English UI. Hence, we had introduced localization to our app, so that the language of YoziCare would be the same as the users’ default language.

## Installation instructions and dependencies

### Android Studio Environment

- Android Studio (2022.1.1)
- Android SDK : Android 13.0 (Tiramisu), API LEVEL-33
- install Flutter Dart plugin 

### Usage

1. To start working on this project, you should clone this repository into your local machine by using the following command.
```bash
git clone https://github.com/oscarchew/kidney.git
```

2. Please install the recommended version of Android Studio and set up the appropriate environment before opening the project.
3. After setting up the environment, please enter the following command in the terminal to install the package.
```bash
flutter pub get
```
4. Place your Service Account Key associated with Dialogflow API under the directory assets/ and name it credentials.json
5. Add your API key related to Google Maps API in the following place
- Go to `android/app/src/main/AndroidManifest.xml` line 46 and add your API key
```
<!-- Add for Google Map -->
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_APIKEY"/>
```
- Go to `lib/presentation/screens/home/google_maps_all.dart` line 26 and add your API key

```
String apiKey = "YOUR_APIKEY"; // API KEY
```

6. Finally, run main.dart to execute the program. 

⚠️ ***IMPORTANT*** ⚠️
There is a bug in the chatbot's underlying program that needs to be resolved by following the steps below.
1. open SoundStreamPlugin.kt
- if your system is LINUX, go to the path : 
```bash
/home/<your username>/.pub-cache/hosted/pub.dartlang.org/sound_stream-0.3.0/android/src/main/kotlin/vn/casperpas/sound_stream/SoundStreamPlugin.kt
```
- if your system is WINDOWS 10, go to the path : 
```bash
C:\Users\<your username>\AppData\Local\Pub\Cache\hosted\pub.dev\sound_stream-0.3.0\android\src\main\kotlin\vn\casperpas\sound_stream\SoundStreamplugin.kt
```
2. find **onRequestPermissionsResult**, and delete **two** question marks(?).

> override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?): Boolean {

to 

> override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {

## Reference
- [Health Management Manual of Chronic Kidney Disease, Health Promotion Administration, Ministry of Health and Welfare, Taiwan](https://www.hpa.gov.tw/File/Attach/6639/File_6234.pdf)
- [The Advantages and Drawbacks of Methods for Assessing Kidney Function in Clinical Practice, Taiwan Society of Internal Medicine](http://www.tsim.org.tw/journal/jour23-1/05.PDF)
- [off-nutrition-table-extractor](https://github.com/openfoodfacts/off-nutrition-table-extractor)
- [Inverse Cooking: Recipe Generation from Food Images](https://github.com/facebookresearch/inversecooking)

## Contact us
- Oscar Chew oscarchew98@gmail.com
- Hsieh, Tzu-Tsen yammy0623@gmail.com
- Wei, Tzu-Shuo r10944006@csie.ntu.edu.tw
- Lo, Hong-Yu b09602059@g.ntu.edu.tw



