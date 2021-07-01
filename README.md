# Damanna iOS
## 👋 Damanna App 소개
&nbsp;&nbsp;&nbsp;&nbsp;관심사가 같은 사람들끼리 모여 대화를 할 수 있는 애플리케이션입니다
<br>
<br>
<p align='center'>
    <img src="https://img.shields.io/badge/Swift-v5.0-FA7343?logo=Swift"/>
    <img src="https://img.shields.io/badge/SpringBoot-v2.45-6DB33F?logo=SpringBoot"/>
    <img src="https://img.shields.io/badge/MongoDB-47A248?logo=MongoDB"/>
    <img src="https://img.shields.io/badge/Heroku-430098?logo=Heroku"/>
    <img src="https://img.shields.io/badge/Gradle-6.8.3-02303A?logo=Gradle"/>
</p>
<br>

> ## 🔨 사용한 API 
<br>
<div align='center'>
    <img src="https://user-images.githubusercontent.com/44153216/124066304-67a6a200-da73-11eb-915c-b655746fba86.png" width="15%"></img>&nbsp;&nbsp;&nbsp;
    <img src="https://user-images.githubusercontent.com/44153216/124066463-accad400-da73-11eb-94ef-a31ff9573eda.png" width="15%"></img>&nbsp;&nbsp;&nbsp;
    <img src="https://user-images.githubusercontent.com/44153216/124066636-003d2200-da74-11eb-9951-6eea240fdc27.png" width="20%"></img>
</div>
<br>

## 🧑‍💻 Member
| 최인제 <img src="https://noticon-static.tammolo.com/dgggcrkxq/image/upload/v1582581609/noticon/cczbpahp5od6voerbvwr.svg" width="12px;"/> | 이유찬 <img src="https://user-images.githubusercontent.com/44153216/124068070-7beb9e80-da75-11eb-8bad-dcc6ebd3c3ce.png" width="12px;"/>|
|-----|-----|
|[@injeChoi](https://github.com/injeChoi)|[@yuchanleeme](https://github.com/yuchanleeme)|
<br>

# 🏃🏻‍♂️ 실행 방법
># Frontend Configuration
## &nbsp;&nbsp;&nbsp;&nbsp;Build on iPhone11 is recommended
<br>

>## Frontend
### 1. git clone
```zsh
git clone https://github.com/Damanna/Damanna_Frontend.git
```
### 2. move directory & pod install 
```zsh
cd Damanna_Frontend/DamannaFront
pod install
```
### 3. run xcode & build
<br><br>

># Backend Configuration
## &nbsp;&nbsp;&nbsp;&nbsp;./src/main/resources/application.properties
```properties
...
spring.data.mongodb.uri=${MONGODB_URI}              // MongoDB URI
spring.data.mongodb.database=${MONGODB_DATABASE}    // Target MongoDB Database Name
...
```
>## Backend
### 1. git clone
```bash
git clone https://github.com/Damanna/Damanna_Backend.git
```
### 2. move directory & build
```
cd Damanna_Backend
gradle build
```

