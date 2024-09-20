# Smart Cleaner

The **Smart Cleaner** app is designed to manage and optimize cleaning operations using smart tracking and real-time data. It allows **Admins**, **Workers**, and **Users** to interact with features like route mapping, location tracking, weather statistics, and robot path optimization, creating a seamless and efficient cleaning experience.

## 1.0 Introduction

**Smart Cleaner** aims to streamline cleaning processes by integrating modern technologies like real-time maps, weather data, and automated robot paths. The app is designed to serve three primary roles: **Admin**, **Worker**, and **User**, each with specific permissions and functions. With the ability to track and manage cleaning routes efficiently, **Smart Cleaner** enhances productivity and transparency in cleaning services.

## 1.1 Problem Domain

- **Manual Cleaning Inefficiency**: Traditional cleaning operations suffer from inefficiency due to lack of optimized route planning and unpredictable weather.
- **Tracking and Accountability Issues**: Without digital tools, it's difficult to track the progress of cleaning tasks and ensure accountability.
- **Robot Path Management**: Efficient path planning for cleaning robots is necessary for automation but lacks sufficient optimization in current solutions.

## 1.2 Proposed System

The **Smart Cleaner** app offers a centralized platform where:

- **Admins** manage cleaning operations and assign tasks.
- **Workers** receive tasks and track their progress in real-time.
- **Users** can monitor the cleanliness of their environment, view weather conditions, and track robot cleaning paths.

The app uses data-driven techniques like weather forecasting and real-time location tracking to enhance cleaning efficiency.

### 1.3.1 Aims and Objectives

The main objectives of **Smart Cleaner** are:

- **Optimize Cleaning Operations**: Ensure efficiency by using smart tracking and real-time data.
- **Enhance Accountability**: Track worker progress and robot paths for better management and control.
- **Adapt to Weather Conditions**: Incorporate real-time weather data to plan cleaning activities accordingly.
- **User-Friendly Interface**: Provide easy access for all roles — Admin, Worker, and User.

### 1.3.2 Key Features

- **Track Map**: Real-time tracking of cleaning activities with a detailed map view for route planning and task completion.
- **Location Tracking**: Workers and robots are tracked to ensure efficiency and coverage of assigned areas.
- **Weather Statistics**: Real-time weather updates to adjust cleaning schedules and routes accordingly.
- **Robot Path Management**: Define and manage robot cleaning paths for automated cleaning services.
- **Role-Based Access**:
  - **Admin**: Assigns tasks, tracks progress, and manages cleaning operations.
  - **Worker**: Receives tasks, follows optimized routes, and completes cleaning assignments.
  - **User**: Monitors cleaning activities and checks overall environment cleanliness.

## 1.4 Roles

1. **Admin**
   - Manage cleaning operations, task assignments, and overall service optimization.
   - Oversee route planning, weather data integration, and robot path management.
  
2. **Worker**
   - Receive and execute cleaning tasks based on optimized routes.
   - Use real-time tracking to complete tasks and report back to the admin.

3. **User**
   - Monitor the cleanliness of an area.
   - View weather conditions and check cleaning task progress.

## 1.5 Getting Started

### Prerequisites

- **Mobile Device**: Android or iOS for Admin, Worker, and User interfaces.
- **GPS Enabled**: To ensure real-time location tracking.
- **Internet Connection**: Required for real-time data such as maps, weather updates, and robot paths.

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/username/smart-cleaner.git
    ```

2. Navigate to the project directory:

    ```bash
    cd smart-cleaner
    ```

3. Install dependencies:

    ```bash
    flutter pub get
    ```

4. Run the app:

    For Android:

    ```bash
    flutter run
    ```

## 1.6 Future Roadmap

- **Enhanced AI Path Optimization** for robots to reduce cleaning time and increase efficiency.
- **Integration with More Weather APIs** for detailed local forecasts and data-driven cleaning schedules.
- **In-app Notifications and Alerts** for workers and admins regarding weather changes and task updates.

## 1.7 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## 1.8 Support and Feedback

For any issues, suggestions, or support, please open an issue on GitHub or contact us at support@smartcleanerapp.com.
