# Google ML Kit Text Recognition rules
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
-dontwarn com.google.mlkit.vision.text.common.**
-dontwarn com.google.mlkit.vision.text.**
-dontwarn com.google.mlkit.**

# Keep the base classes used by the plugin
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text_common.** { *; }

# Additional ML Kit rules for R8 missing classes
-keep class com.google.mlkit.vision.text.TextRecognizer { *; }
-keep class com.google.android.gms.tasks.** { *; }
