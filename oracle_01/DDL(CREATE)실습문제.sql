-- 실습문제 --
-- 도서관리 프로그램을 만들기 위한 테이블들 만들기 --
-- 이때, 제약조건에 이름을 부여할 것 
--      각 컬럼에 주석달기

-- 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER) 
-- 컬럼 : PUB_NO(출판사번호) -- 기본키(PUBLISHER_PK)
--        PUB_NAME(출판사명) -- NOT NULL(PUBLISHER_NN)
--        PHONE(출판사전화번호) -- 제약조건 없음

-- 3개 정도의 샘플 데이터 추가하기
DROP TABLE TB_PUBLISHER;

CREATE TABLE TB_PUBLISHER(
    PUB_NO NUMBER,
    PUB_NAME VARCHAR(20) CONSTRAINT PUBLISHER_NN NOT NULL,
    PHONE VARCHAR(20),
    CONSTRAINT PUBLISHER_PK PRIMARY KEY(PUB_NO)
);

SELECT * FROM USER_CONSTRAINTS;
COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사전화번호';

insert into TB_PUBLISHER values(1, '북박스', '054-252-8933'); 
insert into TB_PUBLISHER values(2, '더블유북스', '02-867-4626'); 
insert into TB_PUBLISHER values(3, '크라운출판사', '02-1566-5937'); 

SELECT*FROM TB_PUBLISHER;


-- 도서들에 대한 데이터를 담기위한 도서 테이블(TB_BOOK)
-- 컬럼 : BK_NO (도서번호) -- 기본키(BOOK_PK)
--        BK_TITLE (도서명) -- NOT NULL(BOOK_NN_TITLE)
--        BK_AUTHOR(저자명) -- NOT NULL(BOOK_NN_AUTHOR)
--        BK_PRICE(가격)
--        BK_PUB_NO(출판사번호) -- 외래키(BOOK_FK) (TB_PUB 테이블을 참조하도록)
--                                  이때 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정

-- 5개 정도의 샘플 데이터 추가하기

CREATE TABLE TB_BOOK(
    BK_NO NUMBER CONSTRAINT BOOK_PK PRIMARY KEY,
    BK_TITLE VARCHAR2(50) CONSTRAINT BOOK_NN_TITLE NOT NULL,
    BK_AUTHOR VARCHAR2(30) CONSTRAINT BOOK_NN_AUTHOR NOT NULL,
    BK_PRICE NUMBER,
    BK_STOCK NUMBER DEFAULT 1,
    BK_PUB_NO NUMBER CONSTRAINT BOOK_FK REFERENCES TB_PUBLISHER ON DELETE CASCADE
);

COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_STOCK IS '재고';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사번호';


insert into TB_BOOK values(1, '이드','김대우',6750,5,1); 
insert into TB_BOOK values(2, '재능만렙플레이어','비츄',2880,5,2); 
insert into TB_BOOK values(3, '꿈속퀘스트보상은현실에서','호영',2880,3,2);
insert into TB_BOOK values(4, '운전면허학과필기문제','도로교통공단',11700,20,3); 
insert into TB_BOOK values(5, '이륜자동차면허필기문제','도로교통공단',11700,15,3); 

SELECT 
    BK_NO 도서번호,
    BK_TITLE 도서명,
    BK_AUTHOR 저자명,
    BK_PRICE 가격,
    BK_STOCK 재고,
    BK_PUB_NO 출판사번호
FROM TB_BOOK;

-- 회원에 대한 데이터를 담기위한 회원 테이블 (TB_MEMBER)
-- 컬럼명 : MEMBER_NO(회원번호) -- 기본키(MEMBER_PK)
--         MEMBER_ID(아이디)   -- 중복금지(MEMBER_UQ)
--         MEMBER_PWD(비밀번호) -- NOT NULL(MEMBER_NN_PWD)
--         MEMBER_NAME(회원명) -- NOT NULL(MEMBER_NN_NAME)
--         GENDER(성별)        -- 'M' 또는 'F'로 입력되도록 제한(MEMBER_CK_GEN)
--         ADDRESS(주소)       
--         PHONE(연락처)       
--         STATUS(탈퇴여부)     -- 기본값으로 'N'  그리고 'Y' 혹은 'N'으로만 입력되도록 제약조건(MEMBER_CK_STA)
--         ENROLL_DATE(가입일)  -- 기본값으로 SYSDATE, NOT NULL 제약조건(MEMBER_NN_EN)

-- 5개 정도의 샘플 데이터 추가하기

DROP TABLE TB_MEMBER;

CREATE TABLE TB_MEMBER(
    MEMBER_NO NUMBER CONSTRAINT MEMBER_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) CONSTRAINT MEMBER_UQ UNIQUE,
    MEMBER_PWD VARCHAR2(30) CONSTRAINT MEMBER_NN_PWD NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_NN_NAME NOT NULL,
    GENDER VARCHAR2(3) CHECK(GENDER IN('M','F')),
    ADDRESS VARCHAR2(100),
    PHONE VARCHAR2(30),
    STATUS VARCHAR2(10) DEFAULT 'N' CHECK(STATUS IN('Y','N')),
    ENROLL_DATE VARCHAR2(30)
);

COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '아이디';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원명';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN TB_MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';

INSERT INTO TB_MEMBER values(100, 'user01','pass01','현조','F','서울특별시','010-1234-5678','N',SYSDATE); 
INSERT INTO TB_MEMBER values(200, 'user02','pass02','김태연','F','인천광역시','010-2345-6789','N',SYSDATE); 
INSERT INTO TB_MEMBER values(300, 'user03','pass03','노한서','M','부산특별시','010-3456-7890','N',SYSDATE); 
INSERT INTO TB_MEMBER values(400, 'user04','pass04','이현규','M','서울특별시','010-4567-8901','N',SYSDATE); 
INSERT INTO TB_MEMBER values(500, 'user05','pass05','최윤종','M','충청북도','010-5678-9012','N',SYSDATE); 

ALTER TABLE TB_MEMBER
RENAME COLUMN MEMBER_PEW TO MEMBER_PWD;

SELECT 
    MEMBER_NO 회원번호,
    MEMBER_ID 아이디,
    MEMBER_PWD 비밀번호,
    MEMBER_NAME 회원명,
    GENDER 성별,
    ADDRESS 주소,
    PHONE 전화번호,
    STATUS 탈퇴여부,
    ENROLL_DATE 가입일
FROM TB_MEMBER;

-- 어떤 회원이 어떤 도서를 대여했는지에 대한  대여목록 테이블(TB_RENT)
-- 컬럼 : RENT_NO(대여번호) -- 기본키(RENT_PK)
--        RENT_MEM_NO(대여회원번호) -- 외래키(RENT_FK_MEM)  TB_MEMBER와 참조하도록
--                                     이때 부모 데이터 삭제시 자식 데이터 값이 NULL이 되도록 옵션 설정
--        RENT_BOOK_NO(대여도서번호) -- 외래키(RENT_FK_BOOK)  TB_BOOK와 참조하도록
--                                      이때 부모 데이터 삭제시 자식 데이터 값이 NULL값이 되도록 옵션 설정
--        RENT_DATE(대여일) -- 기본값 SYSDATE

-- 샘플데이터 3개 정도  추가하기

CREATE TABLE TB_RENT(
    RENT_NO NUMBER CONSTRAINT RENT_PK PRIMARY KEY,
    RENT_MEM_NO NUMBER CONSTRAINT RENT_FK_MEM REFERENCES TB_MEMBER ON DELETE SET NULL,
    RENT_BOOK_NO NUMBER CONSTRAINT RENT_FK_BOOK REFERENCES TB_BOOK ON DELETE SET NULL,
    RENT_DATE DATE DEFAULT SYSDATE
);

COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여회원번호';
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여도서';
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여일';

INSERT INTO TB_RENT VALUES (10091,100,1,SYSDATE);
INSERT INTO TB_RENT VALUES (11091,200,4,SYSDATE);
INSERT INTO TB_RENT VALUES (20234,400,3,SYSDATE);
INSERT INTO TB_RENT VALUES (22234,500,3,TO_DATE('20210909', 'YYMMDD'));

SELECT 
    RENT_NO 대여번호,
    RENT_MEM_NO 대여회원번호,
    RENT_BOOK_NO 대여도서,
    RENT_DATE 대여일
FROM TB_RENT;