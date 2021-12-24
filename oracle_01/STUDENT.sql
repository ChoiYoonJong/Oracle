CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(15) CONSTRAINT PK_MEMBER PRIMARY KEY,
    MEMBER_PWD VARCHAR2(15) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(1) CHECK (GENDER IN ('M','F')),
    AGE NUMBER NOT NULL,
    EMAIL VARCHAR2(30),
    PHONE CHAR(11),
    ADDRESS VARCHAR2(500),
    HOBBY VARCHAR(50),
    ENROLL_DATE DATE DEFAULT SYSDATE
    );


COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.GENDER IS '성별';
COMMENT ON COLUMN MEMBER.AGE IS '나이';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN MEMBER.HOBBY IS '취미';
COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '가입날짜';

SELECT * FROM ALL_COL_COMMENTS WHERE TABLE_NAME='MEMBER'; 
SELECT * FROM USER_TAB_COLUMNS;
    
INSERT INTO MEMBER 
VALUES('admin', 'admin', '관리자', 'M', 30, 'admin@iei.or.kr', '01012345678', '서울시 강남구 역삼동 테헤란호 7',
       '기타, 독서, 운동', '16/03/15');
INSERT INTO MEMBER
VALUES('user11', 'pas11', '홍길동', 'F', 23, 'hong77@kh.org', '01077778888',
       '경기도 수원시 팔달구 팔달동 77', '운동, 등산, 기타', '17/09/21');
INSERT INTO MEMBER
VALUES('user22', 'pass22', '신사임당', 'F', 48, 'shin50@kh.org', '01050005555',
       '강원도 강릉시 오죽헌 5', '독서, 그림, 요리', '17/05/05');
INSERT INTO MEMBER
VALUES('user77', 'user77', '이순신', 'M', 50, 'dltjswnh@naver.com', '01021226374',
       '경기도 시흥시', '음악', '17/12/08');
INSERT INTO MEMBER
VALUES('lsj', 'lsj', '이선주', 'F', 24, 'dltjswnh@naver.com', '01021226374',
       '경기도 안산시', '운동, 음악, 댄스', '17/08/25');
INSERT INTO MEMBER
VALUES('seonn', 'seonn', '김공부', 'F', 28, 'studyll@naver.com', '01021226374',
       '경기도 성남시', '공부, 책읽기', '17/11/08');
       
SELECT * FROM MEMBER;