-- 프로시져(PROCEDURE)
-- : PL/SQL문을 저장하는 객체이다.
--   필요할 때마다 복잡한 구문을 다시 입력할 필요 없이
--   호출을 통해서 간단히 실행시키기 위한 목적으로 사용된다.
/*
@ 프로시져 작성 및 실행 방법

CREATE PROCEDURE 프로시져이름 (매개변수명1 [IN|OUT|INOUT] 자료형, 매개변수명 2[MODE] 자료형...)
	-- IN : 데이터를 전달 받을 때
	-- OUT : 수행된 결과를 받아갈 때
	-- INOUT : 두 가지 목적에 모두 사용 (실제로는 사용되지 않음!)
IS
	지역변수 선언;
BEGIN
	실행할 문장 1;
	실행할 문장 2;
	실행할 문장 3;
	-- 함수호출, 초기화, 절차적 요소, SQL 문
END;
/


@ 실행 방법
EXECUTE 프로시져[(전달값1, 전달값2, ...)];
EXEC 프로시져[(전달값1, 전달값2, ...)];


@ 삭제 
DROP PROCEDURE 프로시져이름;


*/
--테이블 만들기
CREATE TABLE EMP_DUP
AS 
SELECT * FROM EMPLOYEE;

--테이블 조회
SELECT * FROM EMP_DUP;

--프로시져 생성
--EMP_DUP 테이블의 모든 정보를 삭제하는 프로시져 생성하기

CREATE OR REPLACE PROCEDURE DEL_ALL_EMP
IS
BEGIN
    DELETE
    FROM EMP_DUP;
END;
/

EXEC DEL_ALL_EMP;

--테이블 조회
SELECT * FROM EMP_DUP;
-- 삭제가 되어 데이터가 없어진 상태가 되어 나온다.
--ROLLBACK
ROLLBACK;

--프로시져를 관리하는 데이터 딕셔너리
SELECT * FROM USER_SOURCE;-- 생성된프로시져 코드확인
SELECT * FROM ALL_PROCEDURES;--모든프로시져확인
SELECT * FROM USER_PROCEDURES;-- 유저가 생성한 프로시져 목록들을확인
SELECT * FROM USER_SOURCE WHERE NAME = 'DELL_ALL_EMP';

--매개변수있는 프로시저
CREATE OR REPLACE PROCEDURE DEL_EMP_ID
(
    V_EMP_ID EMPLOYEE.EMP_ID%TYPE
)
IS
BEGIN
    DELETE
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
END;
/

--지우고 싶은 아이디 입력시 삭제
EXEC DEL_EMP_ID('&EMP_ID');

-- 조회
SELECT * FROM EMPLOYEE;

-- 롤백
ROLLBACK;

--IN/OUT 매개변수 있는 프로시져
--IN 매개변수 : 프로시져 내부에 사용될 변수
--OUT 매개변수 : 프로시져 호출부에서 사용될 값을 담아 줄 변수

-- 사용자가 입력한 사번으로 사원의 이름, 급여 , 보너스를 조회하는 SELECT_EMP_ID 프로시져 생성
CREATE OR REPLACE PROCEDURE SELECE_EMP_ID
(
    V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
    V_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
    V_SALARY OUT EMPLOYEE.SALARY%TYPE,
    V_BONUS OUT EMPLOYEE.BONUS%TYPE
)
IS
BEGIN
    SELECT
        EMP_NAME,
        SALARY,
        NVL(BONUS,0)
    INTO
        V_EMP_NAME,
        V_SALARY,
        V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
END;
/

-- 바인드변수
-- SQL문을 실행할때 SQL 에 사용값을 전달할수있는 통로역할을 하는 변수
-- 바인드 변수와 매개변수의 자료형은 반드시 같아야한다.
VARIABLE VAR_EMP_NAME VARCHAR2(20);
VARIABLE VAR_SALARY NUMBER;
VARIABLE VAR_BONUS NUMBER;


EXEC SELECT_EMP_ID(201, :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);

PRINT VAR_EMP_NAME;
PRINT VAR_SALARY;
PRINT VAR_BONUS;

SET AUTOPRINT ON;
--별도의 출력 문 없이 바로 print 가능 
--프로시져실행과 동시에 모든 바인딩 변수 출력
EXEC SELECT_EMP_ID(201, :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);

