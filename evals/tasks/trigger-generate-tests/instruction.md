# Instruction

Generate comprehensive test cases for this PRD.

## Product Requirements Document

### Feature: User Profile Management

#### Overview
Allow users to view and edit their profile information including name, email, phone, and avatar.

#### Functional Requirements

1. **View Profile**
   - Users can navigate to profile page via top nav menu
   - Profile displays current user information
   - Avatar displays user's uploaded image or default placeholder

2. **Edit Profile**
   - Users can click "Edit Profile" button to enter edit mode
   - Email field has validation (valid email format required)
   - Phone field accepts US format (###-###-####)
   - Changes are saved via "Save" button
   - Users can cancel without saving via "Cancel" button

3. **Upload Avatar**
   - Users can upload image files (JPG, PNG, max 2MB)
   - Image is automatically cropped to square
   - Preview shown before confirming upload

#### Non-Functional Requirements
- Profile page loads in under 2 seconds
- Supports 1000 concurrent users
- Changes sync to all active sessions within 5 seconds

---

Product Tag: UserManagement
