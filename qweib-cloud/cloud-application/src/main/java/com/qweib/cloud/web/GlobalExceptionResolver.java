package com.qweib.cloud.web;

import com.auth0.jwt.exceptions.SignatureVerificationException;
import com.auth0.jwt.exceptions.TokenExpiredException;
import com.google.common.collect.Lists;
import com.qweib.cloud.biz.common.Response;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.commons.Collections3;
import com.qweib.commons.StringUtils;
import com.qweib.commons.exceptions.BizException;
import com.qweib.commons.exceptions.ErrorDefinition;
import com.qweib.commons.mapper.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;
import java.lang.reflect.Method;
import java.util.List;

@Slf4j
public class GlobalExceptionResolver extends SimpleMappingExceptionResolver {

    @Override
    protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        log.error("error:", ex);
        boolean isAjaxRequest = isAjax(request);

        if (handler instanceof HandlerMethod) {
            HandlerMethod handlerMethod = (HandlerMethod) handler;
            Method method = handlerMethod.getMethod();
            if (method != null) {
                if (AnnotationUtils.findAnnotation(method.getDeclaringClass(), RestController.class) != null ||
                        AnnotationUtils.findAnnotation(method, ResponseBody.class) != null) {
                    isAjaxRequest = true;
                }
            }
        }

        if (isAjaxRequest) {
            // ajax
            Response<?> body = this.createBody(ex);
            Writer writer = null;
            try {
                response.setHeader("Content-Type", "application/json;charset=UTF-8");
                writer = response.getWriter();
                writer.write(JsonMapper.toJsonString(body));
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (writer != null) {
                    try {
                        writer.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
            return null;
        } else {
            return super.doResolveException(request, response, handler, ex);
        }
    }

    private boolean isAjax(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String requestedWithHeader = request.getHeader("X-Requested-With");
        return "XMLHttpRequest".equals(requestedWithHeader) || StringUtils.contains(uri, "/web/");
    }

    private Response createBody(Exception ex) {
        Response response = new Response();
        if (ex instanceof BindException) {
            List<ObjectError> errors = ((BindException) ex).getAllErrors();
            List<PickedError> tiny = Lists.newArrayList();
            for (ObjectError error : errors) {
                FieldError fieldError = (FieldError) error;
                tiny.add(new PickedError(fieldError.getField(), fieldError.getDefaultMessage(), fieldError.getRejectedValue(), fieldError.getCode()));
            }
            response.setCode(ErrorDefinition.INVALID_PARAM.getCode());
            if (Collections3.isNotEmpty(tiny)) {
                response.setMessage(tiny.get(0).getMessage());
            }
        } else if (ex instanceof DataAccessException) {
            if (ex instanceof DuplicateKeyException) {
                response.setCode(500);
                response.setMessage("该项已存在");
            } else {
                response.setMessage(ex.getMessage());
            }
        } else if (ex instanceof DaoException) {
            response.setCode(500);
            response.setMessage("操作失败,请稍后再试");
            log.error("操作失败,请稍后再试", ex);
        } else if (ex instanceof NullPointerException) {
            response.setCode(233);
            response.setMessage("空指针异常");
        } else if (ex instanceof ServiceException) {
            response.setCode(500);
            response.setMessage(ex.getMessage());
        } else if (ex instanceof BizException) {
            response.setCode(((BizException) ex).getCode());
            response.setMessage(ex.getMessage());
        } else if (ex instanceof com.qweib.cloud.core.exception.BizException) {
            response.setCode(((com.qweib.cloud.core.exception.BizException) ex).getCode());
            response.setMessage(ex.getMessage());
        } else if (ex instanceof com.qweibframework.commons.exceptions.BizException) {
            response.setCode(((com.qweibframework.commons.exceptions.BizException) ex).getCode());
            response.setMessage(ex.getMessage());
        } else if (ex instanceof SignatureVerificationException) {
            response.setCode(413);
            response.setMessage("验证失败");
        } else if (ex instanceof TokenExpiredException) {
            response.setCode(413);
            response.setMessage("token已失效");
        } else {
            response.setCode(500);
            response.setMessage("系统繁忙请稍后再试");
            log.error("系统繁忙请稍后再试", ex);
        }
        return response;
    }

    private static class PickedError {
        private String field;
        private String message;
        private Object rejectedValue;
        private String code;

        public PickedError() {
        }

        public PickedError(String field, String message, Object rejectedValue, String code) {
            this.field = field;
            this.message = message;
            this.rejectedValue = rejectedValue;
            this.code = code;
        }

        public String getField() {
            return field;
        }

        public void setField(String field) {
            this.field = field;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public Object getRejectedValue() {
            return rejectedValue;
        }

        public void setRejectedValue(Object rejectedValue) {
            this.rejectedValue = rejectedValue;
        }

        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
        }
    }


}
