
-------------------------------------------
DROP TABLE REPLY;
DROP TABLE BOARD;
DROP TABLE MEMBER;

DROP SEQUENCE SEQ_BNO NOCACHE;
DROP SEQUENCE SEQ_RNO NOCACHE;

--------------------------------------------------
--------------     MEMBER 관련	------------------	
--------------------------------------------------

CREATE TABLE MEMBER (
  USER_ID VARCHAR2(30) PRIMARY KEY,
  USER_PWD VARCHAR2(100) NOT NULL,
  USER_NAME VARCHAR2(15) NOT NULL,
  EMAIL VARCHAR2(100),
  GENDER VARCHAR2(1) CHECK (GENDER IN('M', 'F')),
  AGE NUMBER(3),
  PHONE VARCHAR2(13),
  ADDRESS VARCHAR2(100),
  ENROLL_DATE DATE DEFAULT SYSDATE,
  MODIFY_DATE DATE DEFAULT SYSDATE,
  STATUS VARCHAR2(1) DEFAULT 'Y' CHECK(STATUS IN('Y', 'N'))
);


INSERT INTO MEMBER 
VALUES ('admin', '1234', '관리자', 'admin@kh.or.kr',  'F',33, '010-1111-2222', '서울시 강남구 역삼동', '20191201', '20191201', DEFAULT);

INSERT INTO MEMBER 
VALUES ( 'user01', 'pass01', '유재석','user01@kh.or.kr', 'M',33,'010-3333-4444', '서울시 양천구 목동', '20200301', '20200301', DEFAULT);

COMMIT;



----------------------------------------------------
-----------------     BOARD 관련        ------------------	
----------------------------------------------------

CREATE TABLE BOARD(
  BOARD_NO NUMBER PRIMARY KEY, 
  BOARD_TITLE VARCHAR2(100) NOT NULL,
  BOARD_CONTENT VARCHAR2(4000) NOT NULL,
  BOARD_WRITER VARCHAR2(255),
  ORIGIN_NAME VARCHAR2(255) , 
  CHANGE_NAME VARCHAR2(255) , 
  COUNT NUMBER DEFAULT 0,
  CREATE_DATE DATE,
  STATUS VARCHAR2(1) DEFAULT 'Y' CHECK (STATUS IN('Y', 'N')),
  FOREIGN KEY (BOARD_WRITER) REFERENCES MEMBER 
);

CREATE SEQUENCE SEQ_BNO;

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '첫번째 게시판 서비스를 시작하겠습니다.', '안녕하세요. 첫 게시판입니다.','admin','','', DEFAULT, '20191210', DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '두번째 게시판 서비스를 시작하겠습니다.', '안녕하세요. 2 게시판입니다.','admin','','', DEFAULT, '20200320', DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '하이 에브리원 게시판 서비스를 시작하겠습니다.', '안녕하세요. 3 게시판입니다.','admin','','', DEFAULT, '20200321', DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '안녕.. 마이바티스는 처음이지?', '안녕하세요. 첫 게시판입니다.','admin','','', DEFAULT, '20200322', DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '어서와 ㅎㅎㅎㅎ', '반갑습니다.','admin','','', DEFAULT, '20200323',  DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '페이징 처리때문에 샘플데이터 많이 넣어놓는다...', '안녕하십니까','admin','','',  DEFAULT, '20200324', DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '게시판 서비스', '안녕하세요. 게시판입니다.','admin','','',  DEFAULT, '20200325', DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '샘플데이터들 ', '안녕하세요.','admin','','', DEFAULT, '20200326', DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '모두들 화이팅!!', '화이팅 하세요!!','admin','','', DEFAULT, '20200327', DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '힘내세요!!!', ' 게시판입니다.','admin','','',  DEFAULT, '20200328', DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '게시판 서비스', '프레임워크는 처음이지?','admin','','',  DEFAULT, '20200329', DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '시작하겠습니다.', '지금부터 시작!!','admin','','',  DEFAULT, '20200401', DEFAULT);

INSERT INTO BOARD 
VALUES(SEQ_BNO.NEXTVAL, '마지막 게시판 시작하겠습니다.', '안녕하세요. 마지막 게시판입니다.','admin','','', DEFAULT, '20200402', DEFAULT);



----------------------------------------------------
----------------    REPLY 관련         -------------------	
----------------------------------------------------

CREATE TABLE REPLY(
  REPLY_NO NUMBER PRIMARY KEY,
  REPLY_CONTENT VARCHAR2(400),
  REF_BNO NUMBER,
  REPLY_WRITER VARCHAR2(255),
  CREATE_DATE DATE,
  STATUS VARCHAR2(1) DEFAULT 'Y' CHECK (STATUS IN ('Y', 'N')),
  FOREIGN KEY (REF_BNO) REFERENCES BOARD,
  FOREIGN KEY (REPLY_WRITER) REFERENCES MEMBER
);

CREATE SEQUENCE SEQ_RNO NOCACHE;

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL, '첫번째 댓글입니다.', 1, 'user01', '20191225',  DEFAULT);

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL, '첫번째 댓글입니다.', 13, 'user01', '20200412',  DEFAULT);

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL, '두번째 댓글입니다.', 13, 'user01', '20200413',  DEFAULT);

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL, '마지막 댓글입니다.', 13, 'user01', '20200414',  DEFAULT);



COMMIT;


