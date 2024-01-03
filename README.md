# 추억저장소

## 1. 팀 소개

매순간 해야 할 태스크를 서로 리마인드 해주어야 했던, **황금붕어 팀**

- 허진서 : 고려대학교 컴퓨터학과 21학번
- 송주호 : KAIST 수리과학과 19학번

## 2. 개발 환경

- Framework : Flutter (Language : Dart)
- Tool : Android Studio, VS Code

## 3. 앱 소개

### **시작화면**

<img src="https://github.com/jjjh02/madcamp_1week/assets/62568191/0867f8c2-bed6-4f37-8f5c-73ab0dcc0c4c" width="200" height="400"/>

| 연락처 기능을 하는 Tab1을 ‘인연저장소’로, 갤러리 기능을 하는 Tab2를 ‘장면저장소’로, 캘린더 기능을 하는 Tab3를 ‘만남저장소’로 이름을 정하였습니다. |
| --- |

---

### Tab1 인연저장소

> “*내게 특별한 사람들의 연락처를 저장하고 연락할 수 있는 탭”*
> 
<img src="https://github.com/jjjh02/madcamp_1week/assets/62568191/722a9e07-000f-49de-a260-e49e03a5ecb4" width="200" height="400"/>
<img src="https://github.com/jjjh02/madcamp_1week/assets/62568191/d8fe1739-b53e-47ad-acc9-1c269e060e14" width="200" height="400"/>
<img src="https://github.com/jjjh02/madcamp_1week/assets/62568191/9307bc8a-9e5e-40e3-a0b3-4956f723b9ee" width="200" height="400"/>

| 연락처 리스트가 뜨고 하단 +버튼, 각 연락처마다 수정 아이콘이 뜹니다. |
| --- |
- **기능**
    - 우측 하단 + 버튼을 누르면 연락처 추가창이 떠서 이름, 전화번호, 관계를 저장할 수 있습니다.
    - 특정 연락처를 누르면 연락처 상세정보창이 떠서 적어놓았던 이름, 전화번호, 관계 정보가 뜨고 연락처 삭제가 가능합니다.
    - 또, 전화 아이콘을 누르면 전화앱으로, 문자 아이콘을 누르면 문자앱으로 이동합니다.
    - 연락처 우측에 있는 아이콘을 누르면 연락처 수정창이 떠서 연락처 수정이 가능합니다.
- **구현 방식**
    - `showDialog`를 통해 각각의 팝업창을 띄워 추가, 상세정보 확인, 수정이 가능합니다.
    - 연락처 정보를 `json`형식으로 `contact.json`파일에 저장하고 불러옵니다.
    - 연락처 수정 시 `contact.json`파일뿐만 아니라 `event.json`파일에서 연락처가 사용된 부분을 함께 수정합니다.
    - (연락처 수정 시 `contact.json`파일에서 수정 전 이름을 찾아 수정 후 이름으로 바꿔주고, 캘린더 일정에서 해당 연락처가 쓰였을 시 `event.json`에서 해당 연락처를 찾아 함께 바꿔줍니다.)

---

### Tab2 장면저장소

> “*사람들과 함께한 의미있는 사진을 불러오고 저장할 수 있는 탭”*
>
<img src="https://github.com/jjjh02/madcamp_1week/assets/62568191/20b39542-8a6f-421d-896c-f89ce2ad0b77" width="200" height="400"/>
<img src="https://github.com/jjjh02/madcamp_1week/assets/62568191/6852e481-d48b-4d53-9af6-328e1c9ab042" width="200" height="400"/>
<img src="https://github.com/jjjh02/madcamp_1week/assets/62568191/88b49716-1c20-4f1a-af92-39c3a2813f6e" width="200" height="400"/>
<img src="https://github.com/jjjh02/madcamp_1week/assets/62568191/0508950e-20a2-44c2-85a2-4e1a25336055" width="200" height="400"/>

| 폰 갤러리에서 불러온 이미지가 2열로 보이고 +버튼이 뜹니다. |
| --- |
- **기능**
    - 우측 하단 + 버튼을 누르면 핸드폰 갤러리에 있는 사진을 불러올 수 있습니다.
    - 사진을 불러올 때 팝업창이 떠서 사용자가 날짜를 입력할 수 있습니다. (입력한 날짜는 해당날짜의 일정에 연동이 되어 나타납니다.)
    - 불러온 사진은 2열 그리드뷰로 보여줍니다.
    - 사진을 탭하면 팝업창이 떠서 사진 날짜가 뜨고, 삭제 버튼을 눌러 삭제할 수 있습니다.
- **구현 방식**
    - `image_picker` 패키지를 이용해 폰 갤러리에서 사진을 불러올 수 있습니다.
    - `showDialog`를 통해 저장된 사진의 정보를 팝업으로 띄워 삭제와 닫기가 가능합니다.
    - 이미지 정보를 `json`형식으로 `images_info.json`파일에 저장하고 불러옵니다.

---

### Tab3 만남저장소

> “*기억하고픈 만남 정보를 추가, 저장하고 관련 사진도 볼 수 있는 탭”*
> 
<img src="https://github.com/jjjh02/madcamp_1week/assets/62568191/355afbca-c23e-40d9-8984-72586124ee9e" width="200" height="400"/>
<img src="https://github.com/jjjh02/madcamp_1week/assets/62568191/aac31412-ee4a-4487-9cd2-6f15edddd022" width="200" height="400"/>
<img src="https://github.com/jjjh02/madcamp_1week/assets/62568191/bf1ad937-cfd0-46d0-a835-1bb2e37c6409" width="200" height="400"/>


| 캘린더와 하단 +버튼이 있고, 일정이 있는 날짜를 누르면 일정 리스트가 뜹니다. |
| --- |
- **기능**
    - 우측 하단 + 버튼을 누르면 일정 추가창이 떠서 일정 이름, 약속 시간을 입력하고 사람을 선택할 수 있습니다.
    - 일정을 추가하면 해당 날짜를 눌렀을 때 하단에 일정 리스트가 뜨고 오른쪽 - 아이콘을 누르면 일정 삭제가 가능합니다.
    - 일정 리스트를 눌렀을때 해당 일정에 대한 세부정보 확인이 가능한 창이 뜹니다.
    - 일정 세부정보 창에서는 일정 이름, 일정 시간, 사람을 볼 수 있는데 사람 옆에 있는 > 아이콘을 눌렀을 때에는 그 사람의 연락처 정보를 확인할 수 있습니다. 팝업창의 기능은 tab1의 연락처 상세정보 창과 동일합니다.
- **구현 방식**
    - `table_calendar` 패키지를 사용해서 캘린더를 불러와 사용했습니다.
    - `event.json`으로부터 일정 관련 정보를 `Event` 객체로 저장하고 불러옵니다.
    - 특정 일정을 누르면 `EventInfoPage`로 정보를 넘기고 화면으로 넘어가서 정보를 띄웁니다.

---

### APK 파일
https://drive.google.com/file/d/1aHjwDyh42cXCKEn2_JKMyHCc8UswX703/view?usp=share_link
