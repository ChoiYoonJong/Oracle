/*
3. 도서명이 25자 이상인 책 번호와 도서명을 화면에 출력하는 SQL 문을 작성하시오.
*/
SELECT 
    BOOK_NO "책 번호",
    BOOK_NM "도서명"
FROM TB_BOOK
WHERE LENGTH(BOOK_NM) > 25;
    

/*
4. 휴대폰 번호가 ‘019’로 시작하는 김씨 성을 가진 작가를 이름순으로 정렬했을 때 가장 먼저 표시되는 작가
이름과 사무실 전화번호, 집 전화번호, 휴대폰 전화번호를 표시하는 SQL 구문을 작성하시오.
*/
SELECT
    WRITER_NM "작가이름",
    OFFICE_TELNO "사무실 전화번호",
    HOME_TELNO "집 전화번호",
    MOBILE_NO "휴대폰번호"
FROM(
    SELECT
        WRITER_NM,
        OFFICE_TELNO,
        HOME_TELNO,
        MOBILE_NO
    FROM TB_WRITER
    WHERE MOBILE_NO LIKE '019%'
    AND WRITER_NM LIKE '김%'
    ORDER BY 1)
WHERE ROWNUM = 1;


/*
5. 저작 형태가 “옮김”에 해당하는 작가들이 총 몇 명인지 계산하는 SQL 구문을 작성하시오. (결과 헤더는
“작가(명)”으로 표시되도록 할 것)
*/
SELECT
    COUNT(*) "작가(명)"
FROM TB_WRITER A
LEFT JOIN TB_BOOK_AUTHOR B ON A.WRITER_NO = B.WRITER_NO
WHERE B.COMPOSE_TYPE = '옮김';

/*
6. 300권 이상 등록된 도서의 저작 형태 및 등록된 도서 수량을 표시하는 SQL 구문을 작성하시오.(저작
형태가 등록되지 않은 경우는 제외할 것)
*/
SELECT
    COMPOSE_TYPE "저작형태",
    COUNT(*) "수량"
FROM TB_BOOK_AUTHOR
GROUP BY COMPOSE_TYPE
HAVING COMPOSE_TYPE IS NOT NULL
AND COUNT(*) >= 300;

/*
7. 가장 최근에 발간된 최신작 이름과 발행일자, 출판사 이름을 표시하는 SQL 구문을 작성하시오.
*/
SELECT
    *
FROM(
SELECT
    BOOK_NM "이름",
    ISSUE_DATE "발행일자",
    PUBLISHER_NM "출판사 이름"
FROM TB_BOOK
ORDER BY 2 DESC)
WHERE ROWNUM = 1;


SELECT
    BOOK_NM "이름",
    ISSUE_DATE "발행일자",
    PUBLISHER_NM "출판사 이름"
FROM TB_BOOK
WHERE ISSUE_DATE = (SELECT
                        MAX(ISSUE_DATE) -- 최근출판도서
                    FROM TB_BOOK);
    
/*
8. 가장 많은 책을 쓴 작가 3명의 이름과 수량을 표시하되, 많이 쓴 순서대로 표시하는 SQL 구문을 작성하시오.
*/
SELECT
    *
FROM(
SELECT
    B.WRITER_NM "작가이름",
    COUNT(*) "권 수"
FROM TB_BOOK_AUTHOR A
JOIN TB_WRITER B ON A.WRITER_NO = B.WRITER_NO
GROUP BY B.WRITER_NM
ORDER BY 2 DESC)
WHERE ROWNUM <= 3;

/*
단, 동명이인(同名異人) 작가는 없다고 가정한다. (결과 헤더는 “작가 이름”, “권 수”로 표시되도록 할
것)

9. 작가 정보 테이블의 모든 등록일자 항목이 누락되어 있는 걸 발견하였다. 누락된 등록일자 값을 각 작가의
‘최초 출판도서의 발행일과 동일한 날짜’로 변경시키는 SQL 구문을 작성하시오. (COMMIT 처리할 것)-- 모름
*/
UPDATE TB_WRITER A
SET A.REGIST_DATE = (SELECT
                        MIN(B.ISSUE_DATE) --최초출판도서
                      FROM TB_BOOK B
                      LEFT JOIN TB_BOOK_AUTHOR C ON B.BOOK_NO = C.BOOK_NO
                      WHERE A.WRITER_NO = C.WRITER_NO); -- 서로 작가번호 같음                     

COMMIT;

SELECT *
FROM TB_WRITER;

/*
10. 현재 도서저자 정보 테이블은 저서와 번역서를 구분 없이 관리하고 있다. 앞으로는 번역서는 따로 관리하려
고 한다. 제시된 내용에 맞게 “TB_BOOK_ TRANSLATOR” 테이블을 생성하는 SQL 구문을 작성하시오. 
(Primary Key 제약 조건 이름은 “PK_BOOK_TRANSLATOR”로 하고, Reference 제약 조건 이름은
“FK_BOOK_TRANSLATOR_01”, “FK_BOOK_TRANSLATOR_02”로 할 것)
속성 컬럼 타입 Null PK FK 참조 테이블
도서 번호 BOOK_NO VARCHAR2(10) NOT NULL Y Y TB_BOOK
작가 번호 WRITER_NO VARCHAR2(10) NOT NULL Y Y TB_WRITER
번역 언어 TRANS_LANG VARCHAR2(60) NULL N N 
TB_BOOK 도서 기본 정보 관리 테이블
TB_WRITE 작가(원저자/번역자) 기본 정보 관리 테이블
TB_PUBLISHER 출판사 기본 정보 관리 테이블
TB_BOOK_AUTHOR 도서 및 도서의 저자 정보 관리 테이블
SQL Final Workshop
*/
CREATE TABLE TB_BOOK_TRANSLATOR(
    BOOK_NO VARCHAR2(10), 
    WRITER_NO VARCHAR2(10), 
    TRANS_LANG VARCHAR2(60),
    CONSTRAINT PK_BOOK_TRANSLATOR PRIMARY KEY(BOOK_NO, WRITER_NO)
);

ALTER TABLE TB_BOOK_TRANSLATOR
--ADD CONSTRAINT FK_BOOK_TRANSLATOR_01 FOREIGN KEY (BOOK_NO) REFERENCES TB_BOOK; --BOOK_NO
ADD CONSTRAINT FK_BOOK_TRANSLATOR_02 FOREIGN KEY (WRITER_NO) REFERENCES TB_WRITER; -- WRITER_NO

COMMENT ON COLUMN TB_BOOK_TRANSLATOR.BOOK_NO IS '도서 번호';
COMMENT ON COLUMN TB_BOOK_TRANSLATOR.WRITER_NO IS '작가 번호';
COMMENT ON COLUMN TB_BOOK_TRANSLATOR.TRANS_LANG IS '번역 언어';

/* 
 2 
11. 도서 저작 형태(compose_type)가 '옮김', '역주', '편역', '공역'에 해당하는 데이터는
도서 저자 정보 테이블에서 도서 역자 정보 테이블(TB_BOOK_ TRANSLATOR)로 옮기는 SQL 
구문을 작성하시오. 단, “TRANS_LANG” 컬럼은 NULL 상태로 두도록 한다. (이동된 데이터는 더
이상 TB_BOOK_AUTHOR 테이블에 남아 있지 않도록 삭제할 것)
*/
INSERT INTO TB_BOOK_TRANSLATOR(BOOK_NO, WRITER_NO)
SELECT
    BOOK_NO,
    WRITER_NO
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역');

SELECT * FROM TB_BOOK_TRANSLATOR;

DELETE FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역');

SELECT * FROM TB_BOOK_AUTHOR WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역');

/*
12. 2007년도에 출판된 번역서 이름과 번역자(역자)를 표시하는 SQL 구문을 작성하시오.
*/
SELECT
    A.BOOK_NM "번역서 이름",
    B.WRITER_NO "번역자"
FROM TB_BOOK A
JOIN TB_BOOK_TRANSLATOR B ON A.BOOK_NO = B.BOOK_NO
WHERE EXTRACT(YEAR FROM A.ISSUE_DATE) = 2007;
    
/*
13. 12번 결과를 활용하여 대상 번역서들의 출판일을 변경할 수 없도록 하는 뷰를 생성하는 SQL
구문을 작성하시오. (뷰 이름은 “VW_BOOK_TRANSLATOR”로 하고 도서명, 번역자, 출판일이
표시되도록 할 것)
*/
CREATE VIEW VW_BOOK_TRANSLATOR 
AS
SELECT
    A.BOOK_NM "번역서 이름",
    B.WRITER_NO "번역자",
    A.ISSUE_DATE "출판일"
FROM TB_BOOK A
JOIN TB_BOOK_TRANSLATOR B ON A.BOOK_NO = B.BOOK_NO
WHERE EXTRACT(YEAR FROM A.ISSUE_DATE) = 2007 WITH CHECK OPTION;

SELECT * FROM VW_BOOK_TRANSLATOR;

/*
14. 새로운 출판사(춘 출판사)와 거래 계약을 맺게 되었다. 제시된 다음 정보를 입력하는 SQL
구문을 작성하시오.(COMMIT 처리할 것)
출판사 사무실 전화번호 거래여부
춘 출판사 02-6710-3737 Default 값 사용*/
INSERT INTO TB_PUBLISHER
VALUES
('춘 출판사', '02-6710-3737', Default);

SELECT * FROM TB_PUBLISHER;

COMMIT;

/*
15. 동명이인(同名異人) 작가의 이름을 찾으려고 한다. 이름과 동명이인 숫자를 표시하는 SQL 구문을
작성하시오.*/
SELECT
    WRITER_NM,
    COUNT(*)
FROM TB_WRITER
GROUP BY WRITER_NM
HAVING COUNT(WRITER_NM) > 1;

/*
16. 도서의 저자 정보 중 저작 형태(compose_type)가 누락된 데이터들이 적지 않게 존재한다. 해당 컬럼이
NULL인 경우 '지음'으로 변경하는 SQL 구문을 작성하시오.(COMMIT 처리할 것)*/
UPDATE TB_BOOK_AUTHOR
SET COMPOSE_TYPE = '지음'
WHERE COMPOSE_TYPE IS NULL;

SELECT
    * FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE IS NULL;

COMMIT;

/*
17. 서울지역 작가 모임을 개최하려고 한다. 사무실이 서울이고, 사무실 전화 번호 국번이 3자리인 작가의
이름과 사무실 전화 번호를 표시하는 SQL 구문을 작성하시오.*/
SELECT
    WRITER_NM "작가이름",
    OFFICE_TELNO "사무실전화번호"
FROM TB_WRITER
WHERE SUBSTR(OFFICE_TELNO, 1, 2) = 02
AND SUBSTR(OFFICE_TELNO, 3, 5) LIKE '-___-';

/*
18. 2006년 1월 기준으로 등록된 지 31년 이상 된 작가 이름을 이름순으로 표시하는 SQL 구문을 작성하시오.
*/
SELECT
    WRITER_NM
FROM TB_WRITER
WHERE TO_DATE('2006/01/01', 'YYYY/MM/DD') - REGIST_DATE >= 31*365;

/*
19. 요즘 들어 다시금 인기를 얻고 있는 '황금가지' 출판사를 위한 기획전을 열려고 한다. '황금가지' 
출판사에서 발행한 도서 중 재고 수량이 10권 미만인 도서명과 가격, 재고상태를 표시하는 SQL 구문을
작성하시오. 재고 수량이 5권 미만인 도서는 ‘추가주문필요’로, 나머지는 ‘소량보유’로 표시하고, 
재고수량이 많은 순, 도서명 순으로 표시되도록 한다. */
SELECT
    A.BOOK_NM "도서명",
    A.PRICE "가격",
    CASE WHEN A.STOCK_QTY < 5 THEN '추가주문필요'
        ELSE '소량보유'
    END "재고 상태"
FROM TB_BOOK A
JOIN TB_PUBLISHER B ON A.PUBLISHER_NM = B.PUBLISHER_NM
WHERE B.PUBLISHER_NM = '황금가지'
AND A.STOCK_QTY < 10
ORDER BY A.STOCK_QTY, 1; 
    
/*
20. '아타트롤' 도서 작가와 역자를 표시하는 SQL 구문을 작성하시오. (결과 헤더는
‘도서명’,’저자’,’역자’로 표시할 것)*/
SELECT
    A.BOOK_NM "도서명",
    D.WRITER_NM "저자",
    E.WRITER_NM "역자"
FROM TB_BOOK A -- 책 번호 1991081002
JOIN TB_BOOK_AUTHOR B ON A.BOOK_NO = B.BOOK_NO -- 쓴사람 넘버 286
JOIN TB_BOOK_TRANSLATOR C ON A.BOOK_NO = C.BOOK_NO -- 번역가 넘버 647
JOIN TB_WRITER D ON B.WRITER_NO = D.WRITER_NO -- 쓴사람 이름 고트홀트 에프라임 레씽(GOTTHOLD EPHRAIM LESSING)
JOIN TB_WRITER E ON C.WRITER_NO = E.WRITER_NO -- 번역가 이름 윤도중
WHERE BOOK_NM = '아타트롤';

/*
21. 현재 기준으로 최초 발행일로부터 만 30년이 경과되고, 재고 수량이 90권 이상인 도서에 대해 도서명, 재고
수량, 원래 가격, 20% 인하 가격을 표시하는 SQL 구문을 작성하시오. (결과 헤더는 “도서명”, “재고
수량”, “가격(Org)”, “가격(New)”로 표시할 것. 재고 수량이 많은 순, 할인 가격이 높은 순, 도서명
순으로 표시되도록 할 것
*/
SELECT
    BOOK_NM "도서명",
    STOCK_QTY "재고수량",
    PRICE "가격(Org)",
    PRICE*0.8 "가격(New)"
FROM TB_BOOK
WHERE SYSDATE - ISSUE_DATE >= 30*365
AND STOCK_QTY >= 90
ORDER BY 2 DESC, 4 DESC, 1; 