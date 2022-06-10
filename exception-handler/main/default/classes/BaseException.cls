public inherited sharing virtual class BaseException extends Exception {
    public static final BaseException exceptionBase = new BaseException();
    public list<Exception> exceptions = new List<Exception>();

    public static list<Exception> getExceptions() {
        return BaseException.exceptionBase.exceptions;
    }

    public static Exception catchException(IErrorMessageMapper errorMapper, integer errorCode) {
        return BaseException.exceptionBase.createCustomException(errorMapper, errorCode);
    }

    public static Exception catchException(IErrorMessageMapper errorMapper, integer errorCode, Exception e) {
        return BaseException.exceptionBase.createCustomException(errorMapper, errorCode, e);
    }

    public static Exception catchException(String error, Exception e) {
        return BaseException.exceptionBase.createCustomException(error, e);
    }

    protected virtual Exception createCustomException(IErrorMessageMapper errorMapper, integer errorCode) {
        return createCustomException(errorMapper, errorCode, null);
    }

    protected virtual Exception createCustomException(IErrorMessageMapper errorMapper, integer errorCode, Exception e) {
        return createCustomException(errorMapper.getErrorMsgByCode(errorCode), e);
    }

    protected virtual Exception createCustomException(String error, Exception e) {
        BaseException baseException = new BaseException();
        String errMsg = 'error: ' + error + '\n';
        if (e != null) {
            errMsg += 'Apex Exception:';
            errMsg += 'Error Typ: ' + e.getTypeName() + '\n';
            errMsg += 'StackTraceString: ' + e.getStackTraceString() + '\n';
            errMsg += 'Cause: ' + e.getCause() + '\n';
            errMsg += 'at Line: ' + e.getLineNumber() + '\n';
            errMsg += 'Message: ' + e.getMessage() + '\n';
        }
        baseException.setMessage(errMsg);
        return baseException;
    }
}
