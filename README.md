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

# 🏛 프로젝트 아키텍처
<div align='center'>
    <img src="https://user-images.githubusercontent.com/44153216/124071817-e8b56780-da7a-11eb-8a5a-908ec5a6bf22.png" width="50%"/>
</div>
<br>

## API URI
|번호|유형|URI|설명|
|:---|:---|:---|:---|
|1|GET|/room/read| MongoDB에 Database에 있는 방의 정보를 조회|
|2|POST|/room/save| 방의 정보를 MongoDB에 저장|
|3|Message| /topic/{roomID}| {roomID}를 기준으로 구독|
|4|Message| /chat/sendMessage/{roomID}|{roomID}구독자에게 메세지를 전송|

<br><br>

# 🏃🏻‍♂️ 실행 방법
>## Frontend Configuration
## &nbsp;&nbsp;&nbsp;&nbsp;*Build on iPhone11 is recommended*
<br>

>## Frontend Installation & Build
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

>## Backend Installation & Build
&nbsp;&nbsp;&nbsp;&nbsp;[@Damanna_Backend_Link](https://github.com/Damanna/Damanna_Backend.git)