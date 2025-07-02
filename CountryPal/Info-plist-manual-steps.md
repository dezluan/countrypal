# 📋 Manual Info.plist Configuration for CountryPal

## Method 1: Copy from Source Code (Easiest)

1. **Open Xcode**
2. **Select your CountryPal project** in the navigator
3. **Select the CountryPal target**
4. **Go to the Info tab**
5. **Right-click in the list** and select "Add Row" for each entry below:

## 🔗 URL Schemes (Required for Auth0)

**Add this entry:**
```
Key: CFBundleURLTypes
Type: Array
    Item 0 (Dictionary):
        CFBundleURLName: auth0 (String)
        CFBundleURLSchemes: Array
            Item 0: com.countrypal (String)
```

**Step by step:**
1. Click + to add row
2. Type: `CFBundleURLTypes`
3. Change type to `Array`
4. Click the arrow to expand
5. Click + in the array to add Item 0
6. Change Item 0 type to `Dictionary`
7. Click arrow to expand Item 0
8. Add two sub-items:
   - `CFBundleURLName` (String) = `auth0`
   - `CFBundleURLSchemes` (Array) with Item 0 (String) = `com.countrypal`

## 🌐 App Transport Security (Required for Auth0)

**Add this entry:**
```
Key: NSAppTransportSecurity
Type: Dictionary
    NSAllowsArbitraryLoads: YES (Boolean)
```

**Step by step:**
1. Click + to add row
2. Type: `NSAppTransportSecurity`
3. Change type to `Dictionary`
4. Click arrow to expand
5. Click + to add sub-item
6. Type: `NSAllowsArbitraryLoads`
7. Change type to `Boolean`
8. Set value to `YES`

## 🔍 Query Schemes (Optional but recommended)

**Add this entry:**
```
Key: LSApplicationQueriesSchemes
Type: Array
    Item 0: https (String)
    Item 1: googlechrome (String)
    Item 2: googleauth (String)
    Item 3: com.googleusercontent.apps (String)
```

## 📷 Camera/Photo Access (Optional)

**If you want profile photo functionality:**
```
Key: NSCameraUsageDescription
Type: String
Value: CountryPal would like to access your camera to update your profile photo.

Key: NSPhotoLibraryUsageDescription  
Type: String
Value: CountryPal would like to access your photo library to update your profile photo.
```

## Method 2: Raw Plist Source (Advanced)

1. **Right-click your Info.plist** in Xcode
2. **Open As → Source Code**
3. **Copy the contents** from `Info-additions.plist`
4. **Paste before the closing `</dict>`**
5. **Switch back to Property List view**

## ✅ Verification

After adding these entries, verify:
1. **Build the project** - should build without errors
2. **Check Info tab** - all entries should be visible
3. **URL Schemes** should show `com.countrypal`
4. **Ready for Auth0** when package is added

## 🚨 Important Notes

- **Bundle Identifier**: Make sure `com.countrypal` matches your actual bundle identifier
- **Auth0 URLs**: These must match what you configure in Auth0 dashboard
- **Location Permission**: Already configured from previous location setup
- **Build Clean**: Do a clean build after making these changes

## 🔧 Troubleshooting

**If you see build errors:**
- Verify all entries are correctly typed
- Ensure no typos in keys
- Check that Boolean values are set correctly
- Try cleaning build folder (Cmd+Shift+K)