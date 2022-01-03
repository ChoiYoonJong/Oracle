-- * RTRIM() LTRIM()

-- TRIM(문자열) 문자열 양쪽 공백을 제거한다.
-- RTRIM(문자열, 옵션) 오른쪽 공백이나 문자 제거
-- LTRIM(문자열)/LTRIM(문자열,옵션) 문자열의 왼쪽 공백이나 특정문자를 제거한다.

--TRIM
SELECT TRIM ('ORACLE TUTORIAL') FROM DUAL; 
-- 앞에 서 제거
SELECT TRIM (LEADING '0' FROM '0005489') FROM DUAL; 
-- 뒤에서 제거
SELECT TRIM (TRAILING '0' FROM '5478000') FROM DUAL;
-- 양쪽에서 제거
SELECT TRIM (BOTH '0' FROM '00056470000') FROM DUAL;
-- 0 삭제
SELECT TRIM ( '0' FROM '0003450000') FROM DUAL;


--LTRIM
SELECT LTRIM('ORACLE TUTORIAL') FROM DUAL;
SELECT LTRIM('0000354' , '0') FROM DUAL;
SELECT LTRIM('0000354' , '03') FROM DUAL;
SELECT LTRIM('WOHORACLE','WHO')FROM DUAL;


SELECT
    LTRIM(' Left Trim ')  LT1 ,
    LTRIM(' Left Trim ', 'Left') LT2 ,
    LTRIM(LTRIM(' Left Trim '), 'Left') LT3 
FROM DUAL;

select ltrim('abaabbbcdea', 'a') from dual; 
select ltrim('baaaabbbcdea', 'a') from dual; 
select ltrim(' aaaabbbcdea') from dual; 
select ltrim('가나다라', '가') from dual;
select rtrim('가나다라', '라') from dual;

SELECT job_CODE,
    LTRIM(job_CODE, 'J') LTRIM적용결과,
    RTRIM(job_CODE, '2') RTRIM적용결과
FROM employee;

SELECT * FROM EMPLOYEE;
SELECT 
    EMAIL,
    LTRIM(EMAIL, 's')
FROM EMPLOYEE;
    

--RTRIM
SELECT RTRIM('ORACLE TUTORIAL') FROM DUAL;
SELECT RTRIM('3540000' , '0') FROM DUAL;
SELECT RTRIM('3540000' , '03') FROM DUAL;
SELECT RTRIM('ORACLEWOH','WHO')FROM DUAL;

SELECT * FROM EMPLOYEE;
SELECT 
    EMAIL,
    RTRIM(EMAIL, '@kh.or.kr') 아이디
FROM EMPLOYEE;

SELECT - REPACE 로 변경 가능 
    EMAIL,
    REPLACE(EMAIL, '@kh.or.kr', '@naver.com') 변경된 이메일
  FROM EMPLOYEE;

--  SUBSTR,SUBSTRB,INSTR

-- SUBSTR 함수는 문자단위로 시작위치와 자를 길이를 지정하여 문자열을 자른다
SELECT 
    EMP_NAME, 
    SUBSTR(EMP_NAME, 2),
    SUBSTR(EMP_NAME, 2, 3),
    PHONE,
    SUBSTR(PHONE, 4, 8) "010제외번호" ,
    SUBSTR(PHONE, 4) "010제외번호" 
FROM EMPLOYEE;

--주민 뒤 번호없이 앞에만
SELECT 
    EMP_NO,
    SUBSTR(EMP_NO,1,2 )
FROM EMPLOYEE;

SELECT SUBSTR('oracleclub', 4) name FROM DUAL; -- 4번째부터 이름을 반환

-- 뒤에서 세번째아후 두개의 문자열 반환.
SELECT SUBSTR('oracleclub', -3, 2) name FROM DUAL;

SELECT 
    EMAIL,
    SUBSTR(EMAIL, -9, 9),
    SUBSTR(EMAIL, 1,6)
FROM EMPLOYEE;

-- SUBSTRB

-- SUBSTRB("문자열", "시작위치", "길이") 
SELECT 
    SUBSTRB('ABCDEFG', 1, 4), 
    SUBSTRB('가나다라마바사', 1, 4)
FROM DUAL;

SELECT SUBSTRB('test와테스트',4,1)  AS SUBB_ONE 
           ,SUBSTRB('test와테스트',4,4) AS SUBB_TWO
           ,SUBSTRB('test와테스트',4,7) AS SUBB_THREE
          FROM DUAL;

--한글을 3바이트로 인식함으로써 위와 같이 바이트 단위로 문자열을 잘라서 반환합

SELECT 
    EMP_NAME,
    SUBSTRB (EMP_NAME,1,9) 변경
FROM EMPLOYEE;

SELECT
    EMP_NAME,
    SUBSTRB (EMP_NAME,1,9) 변경,
    EMP_NO,
    SUBSTRB (EMP_NO,1,6) 변경
FROM EMPLOYEE;

SELECT
  EMP_NAME 이름,
  EMP_NO 주민번호,
  SUBSTR(EMP_NO,1,2)||'년' 년도
 FROM EMPLOYEE;
 

--INSTR
-- INSTR ( [문자열], [찾을 문자 값], [찾기를 시작할 위치(1,-1)], [찾은 결과의 순번(1...n)] )
SELECT 
    INSTR('Oracle Database', 'Database') AS result1,
    INSTR('Oracle Database', 'Server')   AS result2
FROM dual;

SELECT 
    INSTR('Oracle Database 12c Release', 'as', 1) AS result1,
    INSTR('Oracle Database 12c Release', 'as')    AS result2
  FROM dual;
  
SELECT
    INSTR('서울역' ,'서울') 결과
FROM DUAL;

SELECT 
    INSTR('Oracle Database 12c Release', 'DATABASE')        AS result1,
    INSTR(UPPER('Oracle Database 12c Release'), 'DATABASE') AS result2
FROM dual;
-- 대문자 구분없이 검색하기 위해서는 UPPER 나 LOVER 변환후 검색해야한다.

SELECT 
    --INSTR('aPPALE IS GOOd' 'APPLE') 결과1,
    INSTR(UPPER('aPPLE IS GOOd'), 'APPLE') 결과2
FROM DUAL;

SELECT 
    EMAIL,
    EMP_NO
FROM EMPLOYEE
WHERE INSTR(EMP_NO, '90') > 0;

SELECT INSTR('ORAas BOBO', 'as', -4) AS result1
FROM dual;

SELECT 
    SUBSTR(EMP_NO,1,6) 주민앞번호,
    SUBSTR(EMP_NO, INSTR(EMP_NO, '-'),7) 주민뒤번호
FROM EMPLOYEE;

SELECT 
    SUBSTR(EMAIL,1,6) 아이디,
    SUBSTR(EMAIL, INSTR(EMAIL, '@'),9) AS  "이메일주소 뒤"
FROM EMPLOYEE;