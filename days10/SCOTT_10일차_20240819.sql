-- 1) 계층적 질의
-- 2) 뷰(View)
SELECT b.b_id, title, price, g.g_id, g_name, p_date, p_su
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON p.b_id = b.b_id
            JOIN gogaek g ON g.g_id = p.g_id;
-- VIEW 생성
CREATE OR REPLACE VIEW uvpan
AS 
    SELECT b.b_id, title, price, g.g_id, g_name, p_date, p_su
            , p_su * price amt
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON p.b_id = b.b_id
                JOIN gogaek g ON g.g_id = p.g_id;
SELECT *
FROM user_sys_privs;
SELECT *
FROM uvpan
ORDER BY p_date DESC;
SELECT *
FROM user_views;
-- 뷰 삭제
DROP VIEW uvpan;

-- 년도, 월, 고객코드, 고객명, 판매금액합(년도별 월별)
-- 년도, 월 오름차순
SELECT TO_CHAR(p_date, 'YYYY')YEAR, TO_CHAR(p_date, 'MM')MONTH
    , g.g_id, g_name, SUM(p_su * price) 판매금액합
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON p.b_id = b.b_id
                JOIN gogaek g ON g.g_id = p.g_id
GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM'), g.g_id, g_name
ORDER BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM')
;

CREATE OR REPLACE VIEW upgagaek
AS SELECT TO_CHAR(p_date, 'YYYY')YEAR, TO_CHAR(p_date, 'MM')MONTH
    , g.g_id, g_name, SUM(p_su * price) 판매금액합
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON p.b_id = b.b_id
                JOIN gogaek g ON g.g_id = p.g_id
GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM'), g.g_id, g_name
ORDER BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM');

SELECT *
FROM upgagaek;

DROP VIEW upgagaek; 

CREATE TABLE testa (
   aid     NUMBER                  PRIMARY KEY
    ,name   VARCHAR2(20) NOT NULL
    ,tel    VARCHAR2(20) NOT NULL
    ,memo   VARCHAR2(100)
);

CREATE TABLE testb (
    bid NUMBER PRIMARY KEY
    ,aid NUMBER CONSTRAINT fk_testb_aid 
            REFERENCES testa(aid)
            ON DELETE CASCADE
    ,score NUMBER(3)
);

INSERT INTO testa (aid, NAME, tel) VALUES (1, 'a', '1');
INSERT INTO testa (aid, name, tel) VALUES (2, 'b', '2');
INSERT INTO testa (aid, name, tel) VALUES (3, 'c', '3');
INSERT INTO testa (aid, name, tel) VALUES (4, 'd', '4');

INSERT INTO testb (bid, aid, score) VALUES (1, 1, 80);
INSERT INTO testb (bid, aid, score) VALUES (2, 2, 70);
INSERT INTO testb (bid, aid, score) VALUES (3, 3, 90);
INSERT INTO testb (bid, aid, score) VALUES (4, 4, 100);

COMMIT;
--
SELECT * FROM testa;
SELECT * FROM testB;

CREATE OR REPLACE VIEW aView
AS
    SELECT aid, name, tel -- , memo
    FROM testa;
SELECT *
FROM aView;
INSERT INTO aView (aid, name, tel) VALUES (5, 'f', '5');
COMMIT;

DELETE FROM aView
WHERE aid = 5;
UPDATE aView
SET tel = '44'
WHERE aid = 4;
COMMIT;
DROP VIEW aView;

CREATE OR REPLACE VIEW abView
AS 
  SELECT 
        a.aid , name , tel   -- testa
        , bid, score         -- testb
   FROM testa a JOIN testb b ON a.aid = b.aid
   WITH READ ONLY;  -- DML X, SELECT O

SELECT *
FROM abView;
-- 복합뷰 INSERT
INSERT INTO abView (aid, name, tel, bid, score)
            VALUES (10, 'x', 55, 20, 70);
-- 동시에 두개 테이블의 각각 칼럼에 값 들을 INSERT 할 수 없다.
--           "                       UPDATE   "
UPDATE abView
SET score = 99
WHERE bid = 1;
-- [WITH CHECK OPTION]
CREATE OR REPLACE VIEW bView
AS
    SELECT bid, aid, score
    FROM testb
    WHERE score >= 90
--    WITH CHECK OPTION CONSTRAINT ch_bview_score
;
SELECT * FROM testb;
SELECT * FROM bView;
UPDATE bView
SET score = 70
WHERE bid= 3;
ROLLBACK;
DROP TABLE testb PURGE;
DROP TABLE testa PURGE;

1. DB 모델링 정의 
  1) 데이터베이스(DataBase) ? 서로 관련된 데이터의 집합(모임)
  2) DB모델링 ? 현실 세계의 업무적인 프로세스를 물리적으로 DB화 시키는 과정.
     예) 스타벅스에서 음료 주문( 현실 세계의 업무 프로세스 )
        음료(상품) 검색 -> 주문 -> 결재 -> 대기 -> 상품 픽업
           
2. DB 모델링 과정(단계, 순서)
   1) 업무 프로세스(요구분석서작성)   →  2) 개념적 DB 모델링(ERD작성)
          ↑ 일치성 검토                                        ↓
   4) 물리적 DB 모델링              ←  3) 논리적 DB 모델링(스키마,정규화)  
      역정규화,
      인덱서
      DBMS(오라클) 타입,크기 등등
      
3. DB 모델링 과정(1단계) - 업무 분석 ->   [ 요구사항명세서(분석서) ] 작성.
   1) 관련 분야에 대한 기본 지식과 상식 필요.
   2) 신입사원의 입장에서 업무 자체와 프로세스 파악,분석 필요.
   3) 우선, 실제 문서(서류, 장표, 보고서 등등)를 수집하고 분석.  p316   (1)
   4) 담당자 인터뷰 , 설문조사 등등 요구사항  직접 수렴.
   5) 비슷한 업무 처리하는 DB 분석
   6) 백그라운드 프로세스 파악.
   7) 사용자와의 요구 분석 
   등등...
   https://terms.naver.com/entry.naver?docId=3431222&ref=y&cid=58430&categoryId=58430
  예) 한빛 마트의 데이터베이스를 위한 요구 사항 명세서
① 한빛 마트에 회원으로 가입하려면 회원아이디, 비밀번호, 이름, 나이, 직업을 입력해야 한다.
② 가입한 회원에게는 등급과 적립금이 부여된다.
③ 회원은 회원아이디로 식별한다.
④ 상품에 대한 상품번호, 상품명, 재고량, 단가 정보를 유지해야 한다.
⑤ 상품은 상품번호로 식별한다.
⑥ 회원은 여러 상품을 주문할 수 있고, 하나의 상품을 여러 회원이 주문할 수 있다.
⑦ 회원이 상품을 주문하면 주문에 대한 주문번호, 주문수량, 배송지, 주문일자 정보를 유지해야 한다.
⑧ 각 상품은 한 제조업체가 공급하고, 제조업체 하나는 여러 상품을 공급할 수 있다.
⑨ 제조업체가 상품을 공급하면 공급일자와 공급량 정보를 유지해야 한다.
⑩ 제조업체에 대한 제조업체명, 전화번호, 위치, 담당자 정보를 유지해야 한다.
⑪ 제조업체는 제조업체명으로 식별한다.
⑫ 회원은 게시글을 여러 개 작성할 수 있고, 게시글 하나는 한 명의 회원만 작성할 수 있다.
⑬ 게시글에 대한 글번호, 글제목, 글내용, 작성일자 정보를 유지해야 한다.
⑭ 게시글은 글번호로 식별한다.

3. DB 모델링 과정(2단계) - 개념적 DB 모델링(ERD작성)
  1) 개념적 DB 모델링 ? DB 모델링을 함에 있어 가장 먼저 해야될 일은 
                      사용자가 필요로하는 데이터가 무엇인지 파악.
                      어떤 데이터를 DB에 저장해야되는 지 충분히 분석
                      ->
                      업무 분석, 사용자 요구 분석등을 통해서 -> 1단계 요구사항명세서 작성
                      수집된 현실 세계의 정보들을 사람들이 이해할 수 있는 
                      명확한 형태로 표현하는 단계를 "개념적 DB모델링"이라고 한다. 
   2) 명확한 형태로 표현하는 방법 ? 1976년 P.Chen 제안
       ㄱ. 개체(Entity) - 직사각형,  관계 모델을 그래프 형식으로 알아보기 쉽게 표현. -> ER-Diagram(ERD)
          ㄴ 실체(Entity)? 업무 수행을 위해 데이터로 관리되어져야할 사람,사물,장소,사건 등을 "실체"한다.
          ㄴ 구축하고자 하는 업무의 목적, 범위, 전략에 따라 데이터로 관리되어져야할 항목을 파악하는 것이
             매우 중요하다. 
          ㄴ 실체는 학생, 교수 등과 같이 물리적으로 존재하는 유형
                   학과, 과목 등과 같이 개념적으로 존재하는 무형.
          ㄴ 실체는 테이블로 정의된다.
          ㄴ 실체는 인스턴스라 불리는 개별적인 객체들의 집합이다.
             예) 과목(실체) : 오라클과목, 자바과목, JSP과목 등등의 인스턴스의 집합.
                 학과(실체) : 컴공과, 전공과 등등 인스턴스의 집합.
          ㄴ 실체를 파악하는 요령 ( 가장 중요 )
             예) 학원에서는 학생들의 출결상태와 성적들을 과목별로 관리하기를 원하고 있다..
                (라고 업무 분석한 내용)
                 - 실체 ? 학원, 학생, 출결상태, 성적, 과목
                               ㄴ 속성 : 학번, 이름, 주소, 연락처, 학과 등등
                                     ㄴ 속성 : 출결날짜, 출석시간, 퇴실시간
       
       ㄴ. 속성(Attribute) - 타원형
           ㄴ 속성 ? 저장할 필요가 있는 실체에 대한 정보
              즉, 속성은 실체의 성질, 분류, 수량, 상태, 특징, 특성 등등 세부항목을 의미한다.
           ㄴ 속성 설정 시 가장 중요한 부분은 관리의 목적과 활용 방향에 맞는 속성의 설정.
           ㄴ 속성의 갯수는  10개 내외가 좋다.
           ㄴ 속성은  컬럼으로 정의된다. 
           ㄴ 속성의 유형
               1) 기본 속성 - 원래 갖고 있는 속성
                  예) 사원실체 - 사원번호 속성, 사원명 속성, 주민등록번호 속성, 입사일자 속성 등등
               2) 파생 속성 - 기본 속성으로 계산해서 얻어질 수 있는 속성
                  예) 기본 속성 주민등록번호에서  생일,성별,나이 속성 등등 
                      판매금액 속성 = 단가 * 판매수량
               3) 설계 속성 - 실제로는 존재하지 않으나 시스템의 효율성을 위해서 설계자가 임의로
                          부여하는 속성
                 예) 주문상태

           ㄴ 속성 도메인 설정
               1) 속성이 가질 수 있는 값들의 범위(세부적인 업무, 제약조건 등 특성을) 정의한 것.
                  예) 성적(E) - 국어(A) 속성의 범위 0~100 정수
                               kor NUMBER(3) DEFAuLT 0 CHECK( kor between 0 and 100)
               2) 도메인 설정은 추후 개발 및 실체를 DB로 생성할 때 사용되는 산출물이다.
               3) 도메인 정의 시에는 속성의 이름, 자료형, 크기, 제약조건 등등. 파악
               4) 도메인 무결성
           ㄴ 식별자(Identifier ): 대표적인 속성 , 언더라인(밑줄)
               1) 한 실체 내에서 각각의 인스턴스를 구분할 수 있는 유일한 단일 속성, 속성 그룹
               2) 식별자가 없으면 데이터를 수정,삭제할 때 문제가 발생한다.
               3) 식별자의 종류
                   (1) 후보키( Candiate Key )
                       실체에 각각의 인스턴스를 구분할 수 있는 속성
                       예) 학생실체(E)   순번, 주민번호, [학번], 이메일, 전화번호, 등등
                           인스턴스 -  홍길동 .........
                           인스턴스 -  김길동 ........
                         
                   (2) 기본키( Primary Key) - [학번]
                       후보키 중에 대표적인 가장 적합한 후보키를 기본키 ...
                       업무적인 효율성, 활용도, 길이(크기) 등등 파악해서 후보키 중에 하나를 기본키로 설정한다. 
                       
                   (3) 대체키( Alternate Key)
                        후보키 - 기본키 = 나머지 후보키
                        - INDEX(인덱스)로 활용된다. 
                        
                   (4) 복합키( Composite Key )
                   (5) 대리키( Surrogate Key )
                      - 학번을 기본키로 사용하자고 결정은 했지만
                      - 식별자가 너무 길거나 여러 개의 복합키로 구성되어 있는 경우 인위적으로 추가한 식별자(인공키)
                      - 전교생이 30명... (순번:일련번호 1~30 )  성능, 효율성을 높이겠다.
                        역정규화 작업
           
       ㄷ. 개체 관계( Relational )  - 마름모
          업무의 연관성에 따라서 실체들 간의 관계 설정..
          예) 부서 실체(E)          <소속관계>        사원 실체(E)
             부서번호속성(식별자)                    사원번호(식별자)
             부서명속성                             사원명
             지역명속성                            입사일자
                                                    :
          예) 학생(E)  <가르침관계>     교수(E)
          예) 상품(E) 실선<주문관계>실선  고객(E)
          
          ㄴ 관계 표현
             1) 두 개체간의 실선으로 연결하고 관계를 부여한다. 
             2) 관계 차수 표현 ( 부서E -01----0N-사원E )   부서 -o| 없거나 1개
                                   1 :  1
                                   N : M ( 다 대 다 )  상품E N0  <주문>  0M 고객E
             3) 선택성 표현  0 , 1
       ㄹ. 연결(링크) - 실선
       https://terms.naver.com/entry.naver?docId=3431223&cid=58430&categoryId=58430&expCategoryId=58430

[비디오샵 DB 모델링]
□ 실무자와 같이 업무적인 설명을 듣고 모델링을 시작해 보자.

   1. 회원제를 실시하는 비디오 상점.
   2. 회원 관리
      ㄱ) 회원이름, 주민번호, 전화번호, 휴대폰번호, 우편번호, 주소, 등록일 등 .
   3. 비디오 테이프 관리
      ㄱ) 장르별, 등급별로 나누어 관리.
      ㄴ) 고유한 일련번호를 부여해서 비디오 테이프를 관리. 
      ㄷ) 영화제목, 제작자, 제작 국가, 주연배우, 감독, 개봉일자, 비디오 출시일 등 상세 정보 관리.
      ㄹ) 파손 여부와 대여 여부 관리.      
   4. 비디오 테이프 대여
      ㄱ) 회수일이 기본 이틀
      ㄴ) 미납 회원들의 목록을 자동으로 관리.
      ㄷ) 연체되었을 경우에는 연체료를 받는다.
      ㄹ) 대여료 신/구 차등 관리.
   5. 포인트 관리 서비스
      ㄱ) 회원에게 대여 1회당 1점씩 포인트 점수를 부여하여 10점이 되면 무료로 TAPE 하나 대여 서비스
   6. 관리자 관리
      ㄱ) 일별 , 월별, 년별 매출액 손쉽게 파악.
      ㄴ) 비디오 테이프의 대여 회수 파악.
      ㄷ) 연체료 관리
      ㄹ) 미납 회원 관리.
      ㅂ) 직원 관리( 근무 시간, 임금 자동 계산 )
      ㅅ) 체인점을 확장해 운영하고 자 함. 

4. DB 모델링 과정(3단계) - 논리적 DB 모델링( 스키마, 정규화 )
https://terms.naver.com/entry.naver?docId=3431227&cid=58430&categoryId=58430&expCategoryId=58430
   ㄴ 개념적 모델링의 결과물(ERD) -> ㄱ. 릴레이션(테이블) 스키마 생성(변환) + 정규화 작업
                                      관계스키마            생성
      
   ㄴ  부모테이블과 자식테이블 구분
      - 관계형 데이터 모델
      - 예)  부서(dept)    <소속관계>       사원(emp)              생성 순서
             부모                          자식
      - 예)   고객         <주문관계>       상품                   생성 순서 X, 관계 주체
             부모                          자식
   ㄴ 기본키(PK)와 외래키(FK)
     dept(deptno PK )
     emp( deptno FK )
   ㄴ (암기)
      식별관계   (실선): 부모테이블의  PK 가 자식테이블의 PK로 전이 되는 것.
      비식별관계 (점선): 부모테이블의  PK 가 자식테이블의 FK로 전이 되는 것.
     
   (1) ERD ->  5가지 규칙(매핑룰) -> 릴레이션 스키마 생성(변환) +  이상현상 발생
                                                           -> 정규화 과정.
       ㄱ. 규칙1: 모든 개체(E)는 릴레이션(Table)으로 변환한다
            개체 -> 테이블
            속성 -> 컬럼
            식별자 -> 기본키 
            
       ㄴ. 규칙2: 다대다(n:m) 관계는 릴레이션으로 변환한다
           고객 N   <주문>   M 상품
       ㄷ. 규칙3: 일대다(1:n) 관계는 외래키로 표현한다
       ㄹ. 규칙4: 일대일(1:1) 관계를 외래키로 표현한다
       ㅁ. 규칙5: 다중 값 속성은 릴레이션으로 변환한다
       
-- [정규화]
-- https://terms.naver.com/entry.naver?docId=3431238&cid=58430&categoryId=58430&expCategoryId=58430
1. 이상현상
  [emp 사원 테이블]
  사원번호(PK) 사원명 입사일자 ...부서명 부서장 내선번호
    1                          영업부 홍길동 102
    
    
    2                          SALES 홍길동 102
    3                          SALES 홍길동 102
    
    
    4                         SALES 홍길동 101
    5                         영업부 홍길동 101

   [emp 사원 테이블]
  사원번호 사원명 입사일자 ....  부서번호(FK)(

  [dept 부서테이블]
  부서번호
  10 SALES 홍길동 105
  20 총무부 김길동 102
  30 생산부 박길동 103

2. 함수 종속성

-------------
ㄱ. 정규화 ? 이상 현상이 발생하지 않도록 하려면,
           관련 있는 속성들로만 릴레이션을 구성해야 하는데 
           이를 위해 필요한 것이 정규화
ㄴ. 함수적 종속성(FD;Functional Dependency) ?    속성들 간의 관련성    
   함수적 종속 ?
   emp 테이블
   empno(PK) ename    ename(Y)은 empno(X)에 함수적으로 종속된다.
      X       Y
    결정자    종속자
      X  →  Y
   
   empno -> ename
   empno -> hiredate
   empno -> job
   
   empno -> (ename, job, mgr, hiredate, sal ,comm, deptno )
      
   SELECT *    
   FROM emp;
   (1) 완전 함수적 종속
       여러 개의 속성이 모여서 하나의 기본키(PK)를 이룰 때   == 복합키
       복합키 전체에 어떤 속성이 종속적일 때 "완전 함수적 종속"이라고 한다. 
       예)
       (고객ID + 이벤트번호)    ->    당첨여부
       
   (2) 부분 함수적 종속 ( 복합키 ) 
       완전 함수 종속이 아니면 "부분 함수적 종속" 이라고 한다. 
        예)
       (고객ID + 이벤트번호)    ->    고객이름  X
        고객ID    ->    고객이름 
        
   (3) 이행 함수적 종속
     Y는 X에 함수적 종속이다.
     결정자 종속자       결정자     종속자
      X      ->  Y          Y     ->   Z          일때    X  ->    Z
     empno   -> deptno    deptno -> dname 
     사원번호  사원명  부서번호  부서명

3. 정규화 정의와 필요성
  (1) 제1 정규형( 1NF )
      릴레이션에 속한 모든 속성의 도메인이 원자 값(atomic value)으로만
      구성되어 있으면 제1정규형에 속한다.

    도메인 ? 속성 하나가 가질 수 있는 모든 값의 집합을 해당 속성의 도메인(domain)이라 한다.
    예) 부서명 컬럼(속성) - 도메인( 영업부, 생산부, 총무부 )

    예)  회원 가입
      취미 선택항목 : [] 여행  [] 사이클 [운동 ].....
      [회원 테이블]
      회원ID(PK) 회원명 ....   취미
                            여행,사이클,독서
                            
      테이블 분리(분해)
     [회원 테이블]
     회원ID(PK)
     admin   홍길동
     
     [회원취미 테이블]
     회원ID(FK)     취미번호(FK)
     admin     10
     admin     20
     admin     40     
     
     [취미테이블]
     PK
     취미번호
     10  여행
     20  사이클
     30  독서
     40  운동 

  (2) 제2 정규형( 2NF )
    릴레이션이 제1정규형에 속하고
    , 기본키가 아닌 모든 속성이 기본키에 "완전 함수 종속"되면 제2정규형에 속한다.
    "부분 함수 종속"을 제거해서 "완전 함수 종속"으로 되면 우리는 제2정규형에 속한다라고 한다.
    복합키  -> 속성
    예) 고객ID  + 이벤트 번호     ->   당첨여부  
                  고객ID         ->     등급  XXX

  (3) 제3 정규형( 3NF )
  릴레이션이 제2정규형에 속하고
  , 기본키가 아닌 모든 속성이 기본키에 "이행적 함수 종속"이 되지 않으면 제3정규형에 속한다.
        X          Z       Y
        X          Y       Z
   사원번호(PK)   부서번호   부서명
   
   
   사원T
   
   사원번호 /부서번호
   
   
   부서T
   부서번호/부서명

  (4) 보이스/코드( BCNF )
  릴레이션의 함수 종속 관계에서 모든 결정자가 후보키이면 보이스/코드 정규형에 속한다.
  
  [X + Y ] 복합키
  [X + Y] -> Z   ,   Z -> Y
  
  [T]
  X,Z
  [T]
  Y,Z

  (5) 제4정규형과 제5정규형
  
--- 물리적 모델링 : 역정규화/인덱스 ...  