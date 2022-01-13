-- PACKAGE
--> 자바의 패키지와 동일한 개념
-- : 프로시져와 함수를 효율적으로 관리하기 위해 묶는 단위
-- : 패키지명.함수명() <- 이런 형태로 사용함

/*
-- 패키지 선언 방법

CREATE [OR REPLACE] PACKAGE 패키지명
IS
	정의될 저장프로시저와 저장함수
END;
/

-- 패키지에 소속된 프로시저나 함수 실행

EXEC 패키지명.저장프로시저명 [(전달값,...)];




-- 패키지의 형식

CREATE [OR REPLACE] PACKAGE package_name

IS
	PROCEDURE procedure_name1;
	PROCEDURE procedure_name2;
END;
/

CREATE [OR REPLACE] PACKAGE package_name
IS
	PROCEDURE procedure_name1
	IS
	...
	END;
END;
/
*/


-- 패키지는 프로시저를 먼저 만들어주고 선언 하는것이 아니고 패키지를 만들고 프로시져만들기
--------------------------------------------------------------------------------

--1. 먼저 패키지를 어떤 프로시저를 넣겠다고 정의한다.

CREATE OR REPLACE PACKAGE KH_PACK
IS
    PROCEDURE SHOW_EMP;
    FUNCTION BONUS_CAL(V_ID IN EMPLOYEE.EMP_ID%TYPE) RETURN NUMBER;
END;
/

--2. 해당 패키지에 넣을 프로시저를 정의한다.

CREATE OR REPLACE PACKAGE BODY KH_PACK
IS
    PROCEDURE SHOW_EMP
    IS
        V_EMP EMPLOYEE%ROWTYPE;
        CURSOR C1
        IS
        SELECT EMP_ID,
                EMP_NAME,
                EMP_NO
        FROM EMPLOYEE;
    BEGIN
        FOR V_EMP IN C1 LOOP
        DBMS_OUTPUT.PUT_LINE('사번 :'|| V_EMP.EMP_ID || '이름 :'|| V_EMP.EMP_NAME ||'주민등록번호 :'|| V_EMP.EMP_NO );
        END LOOP;
    END;
    
    FUNCTION BONUS_CAL(V_ID IN EMPLOYEE.EMP_ID%TYPE)
    RETURN NUMBER
    IS
        VSALARY EMPLOYEE.SALARY%TYPE;
        VBONUS NUMBER;
    BEGIN
        SELECT
            SALARY
        INTO
            VSALARY
        FROM EMPLOYEE
        WHERE EMP_ID = V_ID;
    END;

END;
/

EXEC KH_PACK.SHOW_EMP;
VARIABLE BONUS_CAL NUMBER;

EXEC : BONUS_CAL := KH_PACK.BONUS_CAL('&EMP_ID');

SET AUTOPRINT ON;

PRINT BONUS_CAL;

SELECT KH_PACK.BONUS_CAL(EMP_ID) FROM EMPLOYEE;

SELECT * FROM ALL_SOURCE WHERE TYPE='PACKAGE' AND NAME = 'DBMS_OUTPUT';
SELECT * FROM USER_SOURCE WHERE TYPE='PACKAGE';