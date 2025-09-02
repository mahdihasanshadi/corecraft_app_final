# Firebase Setup Instructions

## 🔥 **Firebase Authentication Setup Required**

Your Firebase project is configured, but you need to enable Authentication. Follow these steps:

### **Step 1: Go to Firebase Console**
1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **core-craft-clothing**

### **Step 2: Enable Authentication**
1. In the left sidebar, click **"Authentication"**
2. Click **"Get Started"**
3. Go to **"Sign-in method"** tab
4. Enable **"Email/Password"** authentication:
   - Click on **"Email/Password"**
   - Toggle **"Enable"** to ON
   - Click **"Save"**

### **Step 3: Enable Firestore Database**
1. In the left sidebar, click **"Firestore Database"**
2. Click **"Create database"**
3. Choose **"Start in test mode"** (for development)
4. Select a location (choose closest to your region)
5. Click **"Done"**

### **Step 4: Test the App**
After completing the above steps, your authentication should work properly.

## 🚀 **Current Status**
- ✅ Firebase project configured
- ✅ Android app connected
- ✅ Dependencies installed
- ❌ Authentication not enabled (REQUIRED)
- ❌ Firestore not enabled (REQUIRED)

## 📱 **What Will Work After Setup**
- User registration
- User login
- User logout
- Password reset
- Profile management
- Data storage in Firestore

---

**Note:** The error "Failed to create account" occurs because Authentication is not enabled in your Firebase project. Once you enable it following the steps above, the app will work perfectly!
