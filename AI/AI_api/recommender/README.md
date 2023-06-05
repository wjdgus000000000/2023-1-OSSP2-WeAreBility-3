##[Recommender]
==========

1. 설명
 Recommender api는 사용자가 이용한 산책로의 태그를 기반으로 비슷한 산책로를 추천해 주는 api이다.

2. 알고리즘
 1. 사용자의 id를 입력받는다.
 2. 데이터베이스에서 해당 id의 사용자가 이용했던 산책로의 태그와 완주여부를 가져온다.
 3. 사용자가 이용한 산책로의 태그를 미리 학습된 word2Vec으로 크기 20의 벡터로 변환시킨다.
 4. 모든 원소가 0인 크기 20의 벡터에다가 사용자가 이용한 산책로의 태그 벡터를 다 더한다. 완주를 했을 경우 한번 더 더한다.
 5. 벡터를 더한 횟수만큼 나눠서 평균 벡터를 구한다.
 6. 데이터베이스에서 사용자가 이용했던 산책로를 제외한 산책로의 태그를 갖고와서 word2Vec으로 벡터로 변환한다.
 7. 평균 벡터와 각 산책로의 태그 벡터를 코사인 유사도로 계산한다.
 8. 코사인 유사도 점수가 가장 유사한 순으로 산책로의 id를 반환한다.

3. word2Vec
 학습한 키워드는 다음과 같다.

 '힐링 스타벅스 자연 오솔길 도심 출근길 퇴근길 점심시간 스트레스해소
 한강 공원 성수 강아지 바다 해안가 러닝 맛집 카페 영화 문화 사색
 핫플 서울숲 경복궁 한옥마을 문화재 고양이 개울가 계곡 들판 산 동산 야경 노을 숲길
 강서구 양천구 구로구 영등포구 금천구 동작구 관악구 서초구 강남구 송파구 강동구
 은평구 서대문구 마포구 용산구 중구 종로구 도봉구 강북구 성북구 동대문구 성동구 노원구 중랑구 광진구'

 유사한 단어, 가까운 지역끼리 묶어서 학습을 시켜서, 단어가 유사하거나 지역이 가까운 경우 변환했을 시의 벡터의 모습도 비슷하다.
 
 