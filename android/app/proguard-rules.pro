# Fix for Jackson
-keep class com.fasterxml.jackson.** { *; }
-keep class javax.xml.** { *; }
-keep class org.w3c.dom.** { *; }
-keep class java.beans.** { *; }
-keep class **.zego.** { *; }
-keep class **.**.zego_zpns.** { *; }

# Fix for Conscrypt
-keep class org.conscrypt.** { *; }

# Prevent DOM serialization issues
-keep class com.fasterxml.jackson.databind.ext.** { *; }
-keep class org.w3c.dom.bootstrap.DOMImplementationRegistry { *; }
