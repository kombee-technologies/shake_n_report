# 📘 Jira Developer Platform – OAuth 2.0 App Setup Guide

This document outlines the step-by-step process for creating an OAuth 2.0 app in the Jira Developer Console, retrieving your client credentials, and configuring access to Jira Cloud APIs for creating issues or bugs.

---

## 🔐 Step 1: Create OAuth 2.0 App

1. **Go to the Jira Developer Console**  
   Visit: [https://developer.atlassian.com/console/myapps/](https://developer.atlassian.com/console/myapps/)

2. **Create a New OAuth 2.0 App**
   - Click on the **"Create OAuth 2.0 integration"** button at the top-right corner.
   - Enter your **App Name** and click **Create**.

3. **Access App Dashboard**
   - After creation, you'll be redirected to your app's dashboard.

4. **Get Client ID & Client Secret**
   - Go to the **"Settings"** section of your app.
   - Copy the **Client ID** and **Client Secret** for later use.

---

## 🔗 Step 2: Configure Authorization

1. **Navigate to Authorization Tab**
   - In the app dashboard, go to **"Authorization"** from the left sidebar.

2. **Set Callback URL**
   - Click **Configure**.
   - Provide the **Callback URL** (your backend or frontend endpoint to handle OAuth redirects).
   - Click **Save Changes**.

---

## 🔍 Step 3: Set Required Scopes

To allow the app to access user identity and Jira Cloud APIs, you need to set the correct scopes.

### 3.1 User Identity API

- Click **Configure** under the *User identity API* section.
- Click **Edit Scopes**.
- Enable:
  - `read:me`
- Click **Save**.

### 3.2 Jira API

#### Classic Scopes

- Click **Configure** under *Jira API*.
- Go to **Edit Scopes**.
- Enable the following **Classic Scopes**:
  - `read:jira-work`
  - `read:jira-user`
  - `write:jira-work`

#### Granular Scopes

Also, under *Jira API > Edit Scopes*, enable the following **Granular Scopes**:
- `read:application-role:jira`
- `read:avatar:jira`
- `read:group:jira`
- `read:issue:jira`
- `write:issue:jira`
- `read:attachment:jira`
- `write:attachment:jira`
- `read:issue-type:jira`
- `read:issue-type-hierarchy:jira`
- `read:user:jira`
- `read:project:jira`
- `read:project-category:jira`
- `read:project.component:jira`
- `read:project.property:jira`
- `read:project-version:jira`

Click **Save** once all required scopes are selected.

---

## 🧩 Step 4 (Optional): Set Distribution Sharing Status

If your organization uses Jira Project Management internally:

1. Go to **Distribution** from the sidebar.
2. Click **Edit** next to the **Sharing status**.
3. Select a relevant sharing option (e.g., *Shared with my organization*).
4. Save your changes.

---

## ✅ Final Step: Integration Ready

You have successfully:
- Created a Jira Developer OAuth 2.0 App
- Retrieved Client ID and Client Secret
- Configured callback and permissions
- Prepared the app to interact with Jira Cloud APIs for issue/bug creation

You can now use these credentials and scopes to implement OAuth 2.0 flow in your application and interact with Jira Cloud REST APIs.