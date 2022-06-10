@IsTest
private class BaseExceptionTest {
    @IsTest
    static void throwExceptionTest() {
        String errMessage;
        String exceptedErrMessage = 'try to catch me!';
        try {
            throw BaseException.catchException(exceptedErrMessage, null);
        } catch (BaseException e) {
            errMessage = e.getMessage();
        }
        system.assertEquals('error: ' + exceptedErrMessage + '\n', errMessage, 'exception thrown should be caught');
    }

    @IsTest
    static void validateExceptionTest() {
        test.startTest();
        BaseExceptionTest.ExceptionTest1 test1 = new BaseExceptionTest.ExceptionTest1();
        test1.createException(); //2 exception elements created

        BaseExceptionTest.ExceptionTest2 test2 = new BaseExceptionTest.ExceptionTest2();
        test2.createExceptionOverload1(); //1 exception element created
        test2.createExceptionOverload2(); //1 exception element created
        test.stopTest();

        list<Exception> myExceptions = new List<Exception>();
        myExceptions.addAll(BaseException.getExceptions());

        system.assertEquals(
            4,
            myExceptions.size(),
            'the exceptions across all class should be caught in base class list'
        );

        for (Exception e : myExceptions) {
            if (
                !e.getMessage().contains('exceptionTest1.createException') &&
                !e.getMessage().contains('from ExtendingBaseException') &&
                !e.getMessage().contains('ErrorMessageMapper1 1') &&
                !e.getMessage().contains('ErrorMessageMapper2 0')
            ) {
                system.assert(false, 'defined error message cannot be found');
            }
        }
    }

    class ExceptionTest1 {
        void createException() {
            try {
                insert new account();
            } catch (Exception e) {
                Exception ex = BaseException.catchException('exceptionTest1.createException', e);
                BaseException.getExceptions().add(ex);
            }
            Exception ex = BaseExceptionTest.ExtendingBaseException.catchException(
                'exceptionTest1.createException',
                null
            );
            BaseException.getExceptions().add(ex);
        }
    }

    class ExceptionTest2 {
        void createExceptionOverload1() {
            try {
                insert new account();
            } catch (Exception e) {
                Exception ex = BaseException.catchException(new BaseExceptionTest.ErrorMessageMapper1(), 1, e);
                BaseException.getExceptions().add(ex);
            }
        }
        void createExceptionOverload2() {
            try {
                insert new account();
            } catch (Exception e) {
                Exception ex = BaseException.catchException(new BaseExceptionTest.ErrorMessageMapper2(), 0);
                BaseException.getExceptions().add(ex);
            }
        }
    }

    class ExtendingBaseException extends BaseException {
        protected override Exception createCustomException(String error, Exception e) {
            return super.createCustomException('from ExtendingBaseException', e);
        }
    }

    public class ErrorMessageMapper1 implements IErrorMessageMapper {
        final Map<Integer, String> errorMsgByCode = new Map<Integer, String>{
            0 => 'ErrorMessageMapper1 0',
            1 => 'ErrorMessageMapper1 1'
        };

        public String getErrorMsgByCode(Integer errorCode) {
            return errorMsgByCode.get(errorCode);
        }
    }
    public class ErrorMessageMapper2 implements IErrorMessageMapper {
        final Map<Integer, String> errorMsgByCode = new Map<Integer, String>{ 0 => 'ErrorMessageMapper2 0' };

        public String getErrorMsgByCode(Integer errorCode) {
            return errorMsgByCode.get(errorCode);
        }
    }
}
