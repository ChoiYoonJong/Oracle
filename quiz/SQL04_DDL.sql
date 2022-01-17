-- DDL

-- 1. 계열 정보를 저장할 카테고리 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오. 
CREATE TABLE TB_CATEGORY
(NAME VARCHAR2(10),
USE_YN CHAR(1)DEFAULT 'Y');
  
SELECT * FROM TB_CATEGORY;

-- 2. 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오. 
CREATE TABLE TB_CLASS_TYPE
(NO VARCHAR2(5) PRIMARY KEY,
NAME VARCHAR2(10));

SELECT * FROM TB_CLASS_TYPE;
-- 3. TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY 를 생성하시오. 
--|(KEY 이름을 생성하지 않아도 무방함. 만일 KEY 이를 지정하고자 한다면 이름은 본인이 알아서 적당한 이름을 사용한다.) 
ALTER TABLE TB_CATEGORY ADD PRIMARY KEY(NAME);

-- 4. TB_CLASS_TYPE 테이블의 NANE 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오. 
ALTER TABLE TB_CLASS_TYPE MODIFY (NAME NOT NULL);

-- 5. 두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10 으로, 컬럼명이 NAME 인 것은 마찬가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오. 
ALTER TABLE TB_CATEGORY MODIFY NAME VARCHAR2(20);
ALTER TABLE TB_CLASS_TYPE MODIFY NAME VARCHAR2(20);
ALTER TABLE TB_CLASS_TYPE MODIFY NO VARCHAR2(10);

-- 6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB 를 제외한 테이블 이름이 앞에 붙은 형태로 변경한다. 
ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;
ALTER TABLE TB_CATEGORY RENAME COLUMN USE_YN TO CATEGORY_YN;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;

-- 7. TB_CATEGORY 테이블과 TB_CLASS_TYPE 테이블의 PRINARY KEY 이름을 다음과 같이 변경하시오. 
--    Primary Key 의 이름은 “PK + 컬럼이름 " 으로 지정하시오. (ex. PK_CATEGORY_NAME ) 
ALTER TABLE TB_CATEGORY DROP PRIMARY KEY;
ALTER TABLE TB_CATEGORY ADD CONSTRAINT PK_TB_CATEGORY_NAME PRIMARY KEY (CATEGORY_NAME);

ALTER TABLE TB_CLASS_TYPE DROP PRIMARY KEY;
ALTER TABLE TB_CLASS_TYPE ADD CONSTRAINT PK_TB_CLASS_TYPE_NO PRIMARY KEY (CLASS_TYPE_NO);
-- 8. 다음과 같은 INSERT 문을 수행한다. 
INSERT INTO TB_CATEGORY VALUES ('공학','Y'); 
INSERT INTO TB_CATEGORY VALUES('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y'); 
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT; 

SELECT * FROM TB_CATEGORY;
-- 9. TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모 
--    값으로 참조하도록 FOREIGN KEY 를 지정하시오. 이 때 KEY 이름은 FK_테이블이름_컬럼이름으로 지정한다. (ex. FK_DEPARTMENT_CATEGORY ) 
ALTER TABLE TB_DEPARTMENT
ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY(CATEGORY) REFERENCES TB_CATEGORY (CATEGORY_NAME);


-- 10. 춘 기술대학교 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW 를 만들고자 한다. 아래 내용을 참고하여 적절한 SQL 문을 작성하시오. 
CREATE OR REPLACE VIEW VW_학생일반정보 
    (학번, 학생이름, 주소)
    AS
    SELECT 
        STUDENT_NO 학번,
        STUDENT_NAME 학생이름,
        STUDENT_ADDRESS 주소
    FROM TB_STUDENT;


-- 11. 춘 기술대학교는 1년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행한다. 
--    이를 위해 사용할 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 VIEW 를 만드시오. 
--     이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오(단, 이 VIEW 는 단순 SELECT 만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.) 
CREATE OR REPLACE VIEW VW_학생일반정보
    AS
    SELECT 
        STUDENT_NAME 학생이름,
        DEPARTMENT_NAME 학과이름,
        NVL(PROFESSOR_NAME, '지도교수 없음') 지도교수이름
    FROM TB_STUDENT A
    JOIN TB_DEPARTMENT B ON A.DEPARTMENT_NO = B.DEPARTMENT_NO 
    LEFT JOIN TB_PROFESSOR C ON A.COACH_PROFESSOR_NO = C.PROFESSOR_NO
    ORDER BY 2;

-- 12. 모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 VIEW 를 작성해 보자. 
CREATE OR REPLACE VIEW VW_학과별학생수 AS
    SELECT 
       DEPARTMENT_NAME 학과이름,
       COUNT(*) 학생수
    FROM TB_STUDENT A
    JOIN TB_DEPARTMENT B ON A.DEPARTMENT_NO = B.DEPARTMENT_NO
    GROUP BY DEPARTMENT_NAME;


-- 13. 위에서 생성한 학생일반정보 View 를 통해서 학번이 A213046 인 학생의 이름을 본인 이름으로 변경하는 SQL 문을 작성하시오. 
UPDATE VW_학생일반정보
SET 학생이름 = '최윤종'
WHERE 학번 = 'A213046';

-- 14. 13 번에서와 같이 VIEW를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW를 어떻게 생성해야 하는지 작성하시오. 
CREATE OR REPLACE VIEW VW_학생일반정보
AS
    SELECT 
        STUDENT_NO 학번, 
        STUDENT_NAME 학생이름, 
        STUDENT_ADDRESS 주소 
    FROM TB_STUDENT WITH READ ONLY;

--15 1. 최근 3년동안 수강인원이 가장 많은 3과목을 뽑아서 그 3년동안의 누적 학생수
SELECT 
    A.CLASS_NO,
    A.CLASS_NAME,
    학생인원명
FROM ( SELECT
            A.CLASS_NO,
            A.CLASS_NAME,
            COUNT(B.STUDENT_NO) 학생인원명 ,
            DENSE_RANK() OVER (ORDER BY COUNT(B.STUDENT_NO) DESC) PK
        FROM 
            TB_CLASS A,
            TB_GRADE B
            WHERE A.CLASS_NO = B.CLASS_NO
            AND SUBSTR(TERM_NO,1,4) IN (SELECT *
                                        FROM ( SELECT
                                                    DISTINCT(SUBSTR(TERM_NO,1,4))
                                                FROM TB_GRADE
                                                ORDER BY 1 DESC )
                                        WHERE ROWNUM <= 3 )
             GROUP BY A.CLASS_NO, A.CLASS_NAME
      ) A
WHERE A.PK <= 3;
                                        

--   2. 최근 3년동안 수강인원이 가장 많은 3과목을 뽑아서 그 3과목 전체 년도의 누적 학생수를 구해서 그 중 3위
SELECT 
    C.CLASS_NO,
    C.CLASS_NAME,
    C.학생인원명
FROM ( SELECT
            A.CLASS_NO,
            A.CLASS_NAME,
            COUNT(B.STUDENT_NO) 학생인원명 ,
            DENSE_RANK() OVER (ORDER BY COUNT(B.STUDENT_NO) DESC) PK
        FROM 
            TB_CLASS A,
            TB_GRADE B
            WHERE A.CLASS_NO = B.CLASS_NO
            AND SUBSTR(TERM_NO,1,4) IN (SELECT *
                                        FROM ( SELECT
                                                    DISTINCT(SUBSTR(TERM_NO,1,4))
                                                FROM TB_GRADE
                                                ORDER BY 1 DESC )
                                        WHERE ROWNUM <= 3 )
             GROUP BY A.CLASS_NO, A.CLASS_NAME
      ) C
WHERE C.CLASS_NO IN (SELECT
                        D.CLASS_NO
                    FROM ( SELECT
                                A.CLASS_NO,
                                DENSE_RANK() OVER (ORDER BY COUNT(B.STUDENT_NO) DESC) RK
                            FROM TB_CLASS A
                            JOIN TB_GRADE B ON A.CLASS_NO = B.CLASS_NO
                            WHERE SUBSTR(B.TERM_NO,1,4) IN (
                                                            SELECT *
                                                            FROM (
                                                                    SELECT
                                                                        DISTINCT(SUBSTR(TERM_NO,1,4))
                                                                    FROM TB_GRADE
                                                                    ORDER BY 1 DESC
                                                                 )
                                                            WHERE ROWNUM <= 3
                                                            )
                            GROUP BY A.CLASS_NO, A.CLASS_NAME
                          ) D
                    WHERE D.RK <= 3
                    )
AND ROWNUM <= 3;

